## Create account
### Arguments:
```js
publicKey: String,
signatureAlgorithm: UInt8,
hashAlgorithm: UInt8,
creationFee: UFix64
```
- `publicKey`: Public key of the account as a hexadecimal string
- `signatureAlgorithm`: Signature algorithm for `PublicKey` as raw data

| Algorithm | Raw data |
| --------- | -------- |
| ECDSA_P256 | 1 |
| ECDSA_secp256k1 | 2 |
| BLS_BLS12_381 | 3 |

> **Note**: New Cadence `enum` type has raw data starting from `0` instead of `1`. \
> Thus, it would be increased/decreased by 1 in code's logic to avoid mismatching for `Wallet.PubKey`.
- `hashAlgorithm`: Hash algorithm for `AccountKey` as raw data

| Algorithm | Raw data |
| --------- | -------- |
| SHA2_256 | 1 |
| SHA2_384 | 2 |
| SHA3_256 | 3 |
| SHA3_384 | 4 |
| KMAC128_BLS_BLS12_381 | 5 |
| KECCAK_256 | 6 |

> **Note**: New Cadence `enum` type has raw data starting from `0` instead of `1`. \
> Thus, it would be increased/decreased by 1 in code's logic to avoid mismatching for `Wallet.Key`.
- `creationFee`: Creation fee for the account, minimum is `0.001` FLOW
> **Read more**: [FAQ - Why is there an account minimum balance?](https://developers.flow.com/concepts/start-here/storage#storage-parameters)
### Flow-CLI command line:
```bash
flow transactions send './transactions/1. Create Account.cdc' \
--signer testnet-account \
--network testnet \
--args-json '[
    {"type": "String", "value": "2ca8f4e4d35917a25f909f738b114201468b2ea0b60ebe2cdd9b6ed3eb25717340e12ac97fbf4efa66f3f45f4673127c9d9f717e40ee4c0aac1dea42ae9db3e4"},
    {"type": "UInt8", "value": "0"},
    {"type": "UInt8", "value": "0"},
    {"type": "UFix64", "value": "0.001"}
]'
```

## Get accounts
### Arguments:
```js
publicKey: String,
signatureAlgorithm: UInt8,
hashAlgorithm: UInt8,
creationFee: UFix64
```
- `publicKey`: Public key of the account as a hexadecimal string
- `signatureAlgorithm`: Signature algorithm for `PublicKey` as raw data

| Algorithm | Raw data |
| --------- | -------- |
| ECDSA_P256 | 1 |
| ECDSA_secp256k1 | 2 |
| BLS_BLS12_381 | 3 |

> **Note**: New Cadence `enum` type has raw data starting from `0` instead of `1`. \
> Thus, it would be increased/decreased by 1 in code's logic to avoid mismatching for `Wallet.PubKey`.
- `hashAlgorithm`: Hash algorithm for `AccountKey` as raw data

| Algorithm | Raw data |
| --------- | -------- |
| SHA2_256 | 1 |
| SHA2_384 | 2 |
| SHA3_256 | 3 |
| SHA3_384 | 4 |
| KMAC128_BLS_BLS12_381 | 5 |
| KECCAK_256 | 6 |

> **Note**: New Cadence `enum` type has raw data starting from `0` instead of `1`. \
> Thus, it would be increased/decreased by 1 in code's logic to avoid mismatching for `Wallet.Key`.
### Flow-CLI command line:
```bash
flow scripts execute './scripts/1. Get Accounts.cdc' \
--network testnet \
--args-json '[
   {"type": "String", "value": "2ca8f4e4d35917a25f909f738b114201468b2ea0b60ebe2cdd9b6ed3eb25717340e12ac97fbf4efa66f3f45f4673127c9d9f717e40ee4c0aac1dea42ae9db3e4"},
    {"type": "UInt8", "value": "0"},
    {"type": "UInt8", "value": "0"}
]'
```