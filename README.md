[![Build Status](http://img.shields.io/travis/OpenAddressesUK/jess.svg)](https://travis-ci.org/OpenAddressesUK/jess) [![Dependency Status](http://img.shields.io/gemnasium/OpenAddressesUK/jess.svg)](https://gemnasium.com/OpenAddressesUK/jess) [![Code Climate](http://img.shields.io/codeclimate/github/OpenAddressesUK/jess.svg)](https://codeclimate.com/github/OpenAddressesUK/jess) [![License](http://img.shields.io/:license-mit-blue.svg)](http://OpenAddressesUK.mit-license.org) [![Badges](http://img.shields.io/:badges-5/5-ff6799.svg)](https://github.com/badges/badgerbadgerbadger)

# Jess

A Sinatra app that, when presented with an address, attempts to infer the existence of other addresses using the [OpenAddresses](https://alpha.openaddressesuk.org/) database.

For background on our approach to inference, see this [blog post](https://alpha.openaddressesuk.org/blog/2015/02/12/inference)

# How to use

Simply POST an address in the following format to http://jess.openaddressesuk.org/infer:

```JSON
{
  "saon": null,
  "paon": 1,
  "street": "High Street",
  "locality": null,
  "town": "Testtown",
  "postcode": "SW1A 1AA"
}
```

If the address `7 High Street, Testtown SW1A 1AA` exists, then we can infer that numbers 3 and 5 exist, so the response will be:

```JSON
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
        "paon": 5,
        "street": "High Street",
        "locality": null,
        "town": "Testtown",
        "postcode": "SW1A 1AA"
      }
    ],
    "existing": [
      {
        "saon": null,
        "paon": 7,
        "street": "High Street",
        "locality": null,
        "town": "Testtown",
        "postcode": "SW1A 1AA"
      }
    ]
  }
}
```
