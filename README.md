# Jess

![](https://upload.wikimedia.org/wikipedia/en/1/10/Guess_with_Jess_logo.png)

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
  "addresses": [
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
}
```
