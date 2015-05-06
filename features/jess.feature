Feature: Make sure it's plumbed in correctly

  Scenario: Get root
    When I send a GET request to "/"
    Then the response status should be "200"

  Scenario: Simple inference
    Given I send and accept JSON
    And the following addresses exist:
    | paon | street      | town     | postcode |
    | 5    | HIGH STREET | TESTTOWN | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":1,"street":"HIGH STREET","locality":null,"town":"TESTTOWN","postcode":"SW1A 1AA"}
"""
  Then the JSON response should contain:
"""
{
  "saon": null,
  "paon": 3,
  "street": "HIGH STREET",
  "locality": null,
  "town": "TESTTOWN",
  "postcode": "SW1A 1AA"
}
"""

  Scenario: Inferrence with multiple addresses
    Given I send and accept JSON
    And the following addresses exist:
    | paon | street      | town     | postcode |
    | 7    | HIGH STREET | TESTTOWN | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":1,"street":"HIGH STREET","locality":null,"town":"TESTTOWN","postcode":"SW1A 1AA"}
"""
  Then the JSON response should contain:
"""
[
  {
    "saon": null,
    "paon": 3,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 5,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  }
]
"""

  Scenario: Inferrence with even numbered addresses
    Given I send and accept JSON
    And the following addresses exist:
    | paon | street      | town     | postcode |
    | 10    | HIGH STREET | TESTTOWN | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":2,"street":"HIGH STREET","locality":null,"town":"TESTTOWN","postcode":"SW1A 1AA"}
"""
  Then the JSON response should contain:
"""
[
  {
    "saon": null,
    "paon": 4,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 6,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 8,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  }
]
"""

  Scenario: Inferrence with mixed numbered addresses
    Given I send and accept JSON
    And the following addresses exist:
    | paon | street      | town     | postcode |
    | 10    | HIGH STREET | TESTTOWN | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":1,"street":"HIGH STREET","locality":null,"town":"TESTTOWN","postcode":"SW1A 1AA"}
"""
  Then the JSON response should contain:
"""
[
  {
    "saon": null,
    "paon": 2,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 3,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 4,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 5,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 6,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 7,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 8,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 9,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  }
]
"""


  Scenario: Inference removes silly numbers
    Given I send and accept JSON
    And the following addresses exist:
    | paon        | street      | town     | postcode |
    | 07535056159 | HIGH STREET | TESTTOWN | SW1A 1AA |
    | 966834552   | HIGH STREET | TESTTOWN | SW1A 1AA |
    | 5           | HIGH STREET | TESTTOWN | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":1,"street":"HIGH STREET","locality":null,"town":"TESTTOWN","postcode":"SW1A 1AA"}
"""
  Then the JSON response should contain:
"""
[
  {
    "saon": null,
    "paon": 3,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  }
]
"""

  Scenario: Only infer updwards
    Given I send and accept JSON
    And the following addresses exist:
    | paon | street      | town     | postcode |
    | 25   | HIGH STREET | TESTTOWN | SW1A 1AA |
    | 5    | HIGH STREET | TESTTOWN | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":19,"street":"HIGH STREET","locality":null,"town":"TESTTOWN","postcode":"SW1A 1AA"}
"""
  Then the JSON response should contain:
"""
[
  {
    "saon": null,
    "paon": 21,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 23,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  }
]
"""

  Scenario: Inference removes non-numeric paos
    Given I send and accept JSON
    And the following addresses exist:
    | paon        | street      | town     | postcode |
    | 7-9         | HIGH STREET | TESTTOWN | SW1A 1AA |
    | 5           | HIGH STREET | TESTTOWN | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":1,"street":"HIGH STREET","locality":null,"town":"TESTTOWN","postcode":"SW1A 1AA"}
"""
  Then the JSON response should contain:
"""
[
  {
    "saon": null,
    "paon": 3,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  }
]
"""

  Scenario: Inference puts existing addresses in a seperate array
    Given I send and accept JSON
    And the following addresses exist:
    | paon | street      | town     | postcode |
    | 9   | HIGH STREET | TESTTOWN  | SW1A 1AA |
    | 5    | HIGH STREET | TESTTOWN | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":1,"street":"HIGH STREET","locality":null,"town":"TESTTOWN","postcode":"SW1A 1AA"}
"""
    Then the JSON response should contain:
"""
{
  "addresses": {
    "inferred": [
      {
        "saon": null,
        "paon": 3,
        "street": "HIGH STREET",
        "locality": null,
        "town": "TESTTOWN",
        "postcode": "SW1A 1AA"
      },
      {
        "saon": null,
        "paon": 7,
        "street": "HIGH STREET",
        "locality": null,
        "town": "TESTTOWN",
        "postcode": "SW1A 1AA"
      }
    ],
    "existing": [
      {
        "saon": null,
        "paon": 5,
        "street": "HIGH STREET",
        "locality": null,
        "town": "TESTTOWN",
        "postcode": "SW1A 1AA",
        "url": "http://alpha.openaddressesuk.org/address/*"
      },
      {
        "saon": null,
        "paon": 9,
        "street": "HIGH STREET",
        "locality": null,
        "town": "TESTTOWN",
        "postcode": "SW1A 1AA",
        "url": "http://alpha.openaddressesuk.org/address/*"
      }
    ]
  }
}
"""

  Scenario: Inferrence with existing address as a source
    Given the following addresses exist:
    | paon | street      | town     | postcode |
    | 7    | HIGH STREET | TESTTOWN | SW1A 1AA |
    | 1    | HIGH STREET | TESTTOWN | SW1A 1AA |
    And I send a request to infer from the address "1, HIGH STREET, TESTTOWN, SW1A 1AA"
    Then the JSON response should contain:
"""
[
  {
    "saon": null,
    "paon": 3,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  },
  {
    "saon": null,
    "paon": 5,
    "street": "HIGH STREET",
    "locality": null,
    "town": "TESTTOWN",
    "postcode": "SW1A 1AA"
  }
]
"""

  Scenario: Inferrence with existing address as a source ignores inferred addresses
  Given the following addresses exist:
  | paon  | street      | town     | postcode | source    |
  | 7     | HIGH STREET | TESTTOWN | SW1A 1AA | url       |
  | 1     | HIGH STREET | TESTTOWN | SW1A 1AA | url       |
  | 11    | HIGH STREET | TESTTOWN | SW1A 1AA | inference |
  And I send a request to infer from the address "1, HIGH STREET, TESTTOWN, SW1A 1AA"
  Then the JSON response should contain:
"""
[
{
  "saon": null,
  "paon": 3,
  "street": "HIGH STREET",
  "locality": null,
  "town": "TESTTOWN",
  "postcode": "SW1A 1AA"
},
{
  "saon": null,
  "paon": 5,
  "street": "HIGH STREET",
  "locality": null,
  "town": "TESTTOWN",
  "postcode": "SW1A 1AA"
}
]
"""
  And the JSON response should not contain:
"""
[
{
  "saon": null,
  "paon": 9,
  "street": "HIGH STREET",
  "locality": null,
  "town": "TESTTOWN",
  "postcode": "SW1A 1AA"
}
]
"""

  @timecop
  Scenario: Inferrence with existing address adds provenance
    Given it is currently "2015-01-01T12:00:00"
    And I stub the current_sha to return "5d954baa0b91ed25c42fb060ad659ce68cdd2e45"
    Given the following addresses exist:
    | paon | street      | town     | postcode |
    | 7    | HIGH STREET | TESTTOWN | SW1A 1AA |
    | 1    | HIGH STREET | TESTTOWN | SW1A 1AA |
    And I send a request to infer from the address "1, HIGH STREET, TESTTOWN, SW1A 1AA"
    Then the JSON response should contain:
"""
{
  "activity": {
    "executed_at": "2015-01-01T12:00:00.000+00:00",
    "processing_scripts": "https://github.com/OpenAddressesUK/jess",
    "derived_from": [
      {
        "type": "inference",
        "inferred_from": [
          "http://ernest.openaddressesuk.org/addresses/*",
          "http://ernest.openaddressesuk.org/addresses/*"
        ],
        "inferred_at": "2015-01-01T12:00:00.000+00:00",
        "processing_script": "https://github.com/OpenAddressesUK/jess/blob/5d954baa0b91ed25c42fb060ad659ce68cdd2e45/lib/jess.rb"
      }
    ]
  }
}
"""

  Scenario: Case insensitive
    Given I send and accept JSON
    And the following addresses exist:
    | paon | street      | town     | postcode |
    | 5    | HIGH STREET | TESTTOWN | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":1,"street":"High Street","locality":null,"town":"Testtown","postcode":"SW1A 1AA"}
"""
  Then the JSON response should contain:
"""
{
  "saon": null,
  "paon": 3,
  "street": "HIGH STREET",
  "locality": null,
  "town": "TESTTOWN",
  "postcode": "SW1A 1AA"
}
"""

  Scenario: Inference without numbers
    Given I send and accept JSON
    And the following addresses exist:
    | paon | street      | town     | postcode |
    | BOB  | HIGH STREET | TESTTOWN | SW1A 1AA |
    And I send a POST request to "/infer" with the following:
"""
{"saon":null,"paon":"BOB","street":"HIGH STREET","locality":null,"town":"TESTTOWN","postcode":"SW1A 1AA"}
"""
  Then the JSON response should contain:
"""
{
  "addresses": {
    "inferred": [],
    "existing": []
  }
}
"""
