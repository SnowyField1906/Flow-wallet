#### Create account
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

#### Get Key
```bash
flow scripts execute './scripts/1. Get Accounts.cdc' \
--network testnet \
--args-json '[
   {"type": "String", "value": "2ca8f4e4d35917a25f909f738b114201468b2ea0b60ebe2cdd9b6ed3eb25717340e12ac97fbf4efa66f3f45f4673127c9d9f717e40ee4c0aac1dea42ae9db3e4"},
    {"type": "UInt8", "value": "0"},
    {"type": "UInt8", "value": "0"}
]'
```