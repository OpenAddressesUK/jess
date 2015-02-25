require 'sinatra/base'
require 'mongoid_address_models/require_all'
require 'github/markdown'

Mongoid.load!(File.join(File.dirname(__FILE__), "..", "config", "mongoid.yml"), ENV["RACK_ENV"] || :development)

class Jess < Sinatra::Base
  get '/' do
    erb :index
  end

  post '/infer' do
    if params[:token]
      source = address_hash(Address.find(params[:token]))
    else
      source = JSON.parse(request.body.read)
    end
    addresses = Address.where("street.name" => source["street"], "postcode.name" => source["postcode"]).map { |a| address_hash(a) }
    addresses << source
    # Remove any addresses that start with 0 or are excessively large or are non-numeric
    addresses.delete_if { |a| a["paon"] =~ /^0.+$/ || a["paon"].to_i > 2000 || a["paon"] =~ /[^0-9]/ }
    # Cast PAO as numeric
    addresses.each { |address| address["paon"] = address["paon"].to_i }
    # sort the addresses by paon
    addresses.sort_by! { |a| a["paon"] }
    # Remove paons lower than the source
    addresses.each {|a| addresses.delete(a) if a["paon"] < source["paon"]}
    # Check whether paons are odd, even or both
    state = paon_state(addresses)

    inferred = []
    existing = addresses.reject { |a| a == source }

    min = addresses.first["paon"] + (state == "mixed" ? 1 : 2)
    max = addresses.last["paon"] - (state == "mixed" ? 1 : 2)

    unless state == "mixed"
      (min..max).each do |num|
        inferred << infer(source, num) if num.send("#{state}?")
      end
    else
      (min..max).each do |num|
        inferred << infer(source, num)
      end
    end

    {
      addresses: {
        inferred: inferred.reject { |a| existing.include?(a) },
        existing: existing
      }
    }.tap{ |a| a["provenance"] = add_provenance(source, addresses.last) if params[:token] }.to_json
  end

  def address_hash(address)
    {
      "saon" => address.sao,
      "paon" => address.pao,
      "street" => address.street.name,
      "locality" => address.locality.nil? ? nil : address.locality.name,
      "town" => address.town.name,
      "postcode" => address.postcode.name,
      "url" => "http://alpha.openaddressesuk.org/address/#{address.token}"
    }
  end

  def paon_state(addresses)
    types = addresses.map { |a| a["paon"].even? }.uniq
    if types.count > 1
      "mixed"
    elsif types.first === true
      "even"
    else
      "odd"
    end
  end

  def infer(source, num)
    source.dup.tap { |j| j["paon"] = num }
  end

  def add_provenance(source, inferred)
    {
      activity: {
        executed_at: DateTime.now,
        processing_scripts: "https://github.com/OpenAddressesUK/jess",
        derived_from: [
          {
            type: "inference",
            inferred_from: [
              source['url'],
              inferred['url']
            ],
            inferred_at: DateTime.now,
            processing_script: "https://github.com/OpenAddressesUK/jess/blob/5d954baa0b91ed25c42fb060ad659ce68cdd2e45/lib/jess.rb"
          }
        ]
      }
    }
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
