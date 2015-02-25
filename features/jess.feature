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
  Then the JSON response should contain:
"""
{
  "saon": null,
  "paon": 3,
  "street": "High Street",
  "locality": null,
  "town": "Testtown",
  "postcode": "SW1A 1AA"
}
"""

  Scenario: Inferrence with multiple addresses
    Given I send and accept JSON
    And the following addresses exist:
    | paon | street      | town     | postcode |
    | 7    | High Street | Testtown | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":1,"street":"High Street","locality":null,"town":"Testtown","postcode":"SW1A 1AA"}
"""
  Then the JSON response should contain:
"""
[
  {
    "saon": null,
    "paon": 3,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 5,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  }
]
"""

  Scenario: Inferrence with even numbered addresses
    Given I send and accept JSON
    And the following addresses exist:
    | paon | street      | town     | postcode |
    | 10    | High Street | Testtown | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":2,"street":"High Street","locality":null,"town":"Testtown","postcode":"SW1A 1AA"}
"""
  Then the JSON response should contain:
"""
[
  {
    "saon": null,
    "paon": 4,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 6,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 8,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  }
]
"""

  Scenario: Inferrence with mixed numbered addresses
    Given I send and accept JSON
    And the following addresses exist:
    | paon | street      | town     | postcode |
    | 10    | High Street | Testtown | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":1,"street":"High Street","locality":null,"town":"Testtown","postcode":"SW1A 1AA"}
"""
  Then the JSON response should contain:
"""
[
  {
    "saon": null,
    "paon": 2,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 3,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 4,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 5,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 6,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 7,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 8,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 9,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  }
]
"""


  Scenario: Inference removes silly numbers
    Given I send and accept JSON
    And the following addresses exist:
    | paon        | street      | town     | postcode |
    | 07535056159 | High Street | Testtown | SW1A 1AA |
    | 966834552   | High Street | Testtown | SW1A 1AA |
    | 5           | High Street | Testtown | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":1,"street":"High Street","locality":null,"town":"Testtown","postcode":"SW1A 1AA"}
"""
  Then the JSON response should contain:
"""
[
  {
    "saon": null,
    "paon": 3,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  }
]
"""

  Scenario: Only infer updwards
    Given I send and accept JSON
    And the following addresses exist:
    | paon | street      | town     | postcode |
    | 25   | High Street | Testtown | SW1A 1AA |
    | 5    | High Street | Testtown | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":19,"street":"High Street","locality":null,"town":"Testtown","postcode":"SW1A 1AA"}
"""
  Then the JSON response should contain:
"""
[
  {
    "saon": null,
    "paon": 21,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 23,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  }
]
"""

  Scenario: Inference removes non-numeric paos
    Given I send and accept JSON
    And the following addresses exist:
    | paon        | street      | town     | postcode |
    | 7-9         | High Street | Testtown | SW1A 1AA |
    | 5           | High Street | Testtown | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":1,"street":"High Street","locality":null,"town":"Testtown","postcode":"SW1A 1AA"}
"""
  Then the JSON response should contain:
"""
[
  {
    "saon": null,
    "paon": 3,
    "street": "High Street",
    "locality": null,
    "town": "Testtown",
    "postcode": "SW1A 1AA"
  }
]
"""

  Scenario: Inference puts existing addresses in a seperate array
    Given I send and accept JSON
    And the following addresses exist:
    | paon | street      | town     | postcode |
    | 9   | High Street | Testtown  | SW1A 1AA |
    | 5    | High Street | Testtown | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":1,"street":"High Street","locality":null,"town":"Testtown","postcode":"SW1A 1AA"}
"""
  Then the JSON response should be:
"""
{
  "addresses": {
    "inferred": [
      {
        "saon": null,
        "paon": 3,
        "street": "High Street",
        "locality": null,
        "town": "Testtown",
        "postcode": "SW1A 1AA"
      },
      {
        "saon": null,
        "paon": 7,
        "street": "High Street",
        "locality": null,
        "town": "Testtown",
        "postcode": "SW1A 1AA"
      }
    ],
    "existing": [
      {
        "saon": null,
        "paon": 5,
        "street": "High Street",
        "locality": null,
        "town": "Testtown",
        "postcode": "SW1A 1AA"
      },
      {
        "saon": null,
        "paon": 9,
        "street": "High Street",
        "locality": null,
        "town": "Testtown",
        "postcode": "SW1A 1AA"
      }
    ]
  }
}
"""
