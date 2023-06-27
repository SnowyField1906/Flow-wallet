#### Create account
```bash
flow transactions send './transactions/1. Create Account.cdc' \
--signer testnet-account \
--network testnet \
--args-json '[
    {"type": "String", "value": "0123456789abcdef"},
    {"type": "UInt8", "value": "0"},
    {"type": "UInt8", "value": "0"},
    {"type": "UFix64", "value": "0.001"}
]'
```

#### Get Key
```bash
flow scripts execute './scripts/1. Get Key.cdc' \
--network testnet \
--args-json '[
    {"type": "Address", "value": "0xb941442fdd844a30"}
]'
```