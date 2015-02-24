require 'sinatra/base'
require 'mongoid_address_models/require_all'

Mongoid.load!(File.join(File.dirname(__FILE__), "..", "config", "mongoid.yml"), ENV["RACK_ENV"] || :development)

class Jess < Sinatra::Base
  get '/' do
    'Hello from Jess'
  end

  post '/infer' do
    json = JSON.parse(request.body.read)
    addresses = Address.where("street.name" => json["street"], "postcode.name" => json["postcode"]).map { |a| address_hash(a) }
    addresses << json
    # strip away the non-numeric parts from the PAO
    addresses.each { |address| address["paon"] = address["paon"].to_i }
    # sort the addresses by paon
    addresses.sort! { |a| a["paon"] }
    # Check whether paons are odd, even or both
    state = paon_state(addresses)

    inferred = []
    min = addresses.first["paon"] + 2
    max = addresses.last["paon"] - 2

    unless state == "mixed"
      (min..max).each do |num|
        inferred << json.dup.tap { |j| j["paon"] = num } if num.send("#{state}?")
      end
    end

    {
      addresses: inferred
    }.to_json
  end

  def address_hash(address)
    {
      "saon" => address.sao,
      "paon" => address.pao,
      "street" => address.street.name,
      "locality" => address.locality.nil? ? nil : address.locality.name,
      "town" => address.town.name,
      "postcode" => address.postcode.name
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

  # start the server if ruby file executed directly
  run! if app_file == $0
end
