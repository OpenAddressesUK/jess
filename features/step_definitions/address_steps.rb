Given(/^the following addresses exist:$/) do |addresses|
  addresses.hashes.each do |address|
    FactoryGirl.create(:address,
                      sao: address[:saon],
                      pao: address[:paon],
                      street: FactoryGirl.create(:street, name: address[:street]),
                      locality: address[:locality].nil? ? nil : FactoryGirl.create(:locality, name: address[:locality]),
                      town: FactoryGirl.create(:town, name: address[:town]),
                      postcode: FactoryGirl.create(:postcode, name: address[:postcode]),
                      source: address[:source].nil? ? "url" : address[:source],
                      provenance: {
                        activity: {
                          derived_from: [
                            {
                              type: "Source",
                              urls: [
                                "http://ernest.openaddressesuk.org/addresses/2935071"
                              ],
                            }
                          ]
                        }
                      }
    )
  end
end

Then /^the JSON response should ?(not)? contain:$/ do |match, json|
  expected = Regexp.escape(JSON.parse(json).to_s)
  actual = JSON.parse(last_response.body).to_s

  expected.gsub!("\\*", ".+")

  if match == "not"
    actual.should_not match(/#{expected}/)
  else
    actual.should match(/#{expected}/)
  end
end

Then(/^I send a request to infer from the address "(.*?)"$/) do |address|
  parts = address.split(", ")
  address = Address.where(pao: parts[0], "street.name" => parts[1], "town.name" => parts[2], "postcode.name" => parts[3]).first
  steps %Q{
    And I send a POST request to "/infer" with the following:
    | token | #{address.token} |
  }
end

Given(/^it is currently "(.*?)"$/) do |datetime|
  Timecop.freeze(datetime)
end

Given(/^I stub the current_sha to return "(.*?)"$/) do |sha|
  Jess.any_instance.stub(:current_sha) { sha }
end
