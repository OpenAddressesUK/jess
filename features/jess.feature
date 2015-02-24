Feature: Make sure it's plumbed in correctly

  Scenario: Get root
    When I send a GET request to "/"
    Then the response status should be "200"

  Scenario: Simple inference
    Given I send and accept JSON
    And the following addresses exist:
    | paon | street      | town     | postcode |
    | 5    | High Street | Testtown | SW1A 1AA |

    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":1,"street":"High Street","locality":null,"town":"Testtown","postcode":"SW1A 1AA"}
"""
  Then the JSON response should be:
"""
{
  "addresses": [
    {
      "saon": null,
      "paon": 3,
      "street": "High Street",
      "locality": null,
      "town": "Testtown",
      "postcode": "SW1A 1AA"
    }
  ]
}
"""
