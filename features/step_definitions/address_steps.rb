Given(/^the following addresses exist:$/) do |addresses|
  addresses.hashes.each do |address|
    FactoryGirl.create(:address,
                      sao: address[:saon],
                      pao: address[:paon],
                      street: FactoryGirl.create(:street, name: address[:street]),
                      locality: address[:locality].nil? ? nil : FactoryGirl.create(:locality, name: address[:locality]),
                      town: FactoryGirl.create(:town, name: address[:town]),
                      postcode: FactoryGirl.create(:postcode, name: address[:postcode])
    )
  end
end

Then /^the JSON response should contain:$/ do |json|
  expected = JSON.parse(json).to_s
  actual = JSON.parse(last_response.body).to_s

  expected.should match /#{expected}/
end

Then(/^I send a request to infer from the address "(.*?)"$/) do |address|
  parts = address.split(", ")
  address = Address.where(pao: parts[0], "street.name" => parts[1], "town.name" => parts[2], "postcode.name" => parts[3]).first
  steps %Q{
    And I send a POST request to "/infer" with the following:
    | token | #{address.token} |
  }
end
