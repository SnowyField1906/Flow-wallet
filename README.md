# I. Setup

## 1. Install Flow CLI

### MacOS

```bash
brew install flow-cli
```

### Linux

```powershell
sh -ci "$(curl -fsSL https://raw.githubusercontent.com/onflow/flow-cli/master/install.sh)"
```

### Windows

```powershell
iex "& { $(irm 'https://raw.githubusercontent.com/onflow/flow-cli/master/install.ps1') }"
```

## 2. Create account

Do the following command and follow the instructions:

```bash
flow accounts create
```

> [Flow faucet](https://testnet-faucet-v2.onflow.org/fund-account)

## 3. Config Flow project

Change the `testnet-account` key in [this file](./flow.json) to the account name you have set.

## 4. Deploy contracts

```bash
flow project deploy --network testnet
```

# II. Transactions

> ⚠️ Assuming your account name is `testnet-account`.

## 1. Create Account

### 1.1. Arguments

```js
publicKey: String
signatureAlgorithm: UInt8
hashAlgorithm: UInt8
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
> Thus, it would be increased/decreased by 1 in the code logic to avoid mismatching for `Factory.PubKey`.

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
> Thus, it would be increased/decreased by 1 in the code logic to avoid mismatching for `Factory.Key`.

- `creationFee`: Creation fee for the account, minimum is `0.001` FLOW

> **Read more**: [FAQ - Why is there an account minimum balance?](https://developers.flow.com/concepts/start-here/storage#storage-parameters)
>
### 1.2. Flow-CLI command line

```bash
flow transactions send './transactions/1. Create Account.cdc' \
--signer testnet-account \
--network testnet \
--args-json '[
  {
    "type": "String",
    "value": "2ca8f4e4d35917a25f909f738b114201468b2ea0b60ebe2cdd9b6ed3eb25717340e12ac97fbf4efa66f3f45f4673127c9d9f717e40ee4c0aac1dea42ae9db3e4"
  },
  { "type": "UInt8", "value": "1" },
  { "type": "UInt8", "value": "1" },
  { "type": "UFix64", "value": "0.001" }
]'
```

## 2. Setup FUSD Vault

```bash
flow transactions send './transactions/2. Setup FUSD.cdc' \
--signer testnet-account \
--network testnet \
--args-json '[]'
```

## 3. Setup USDC Vault

```bash
flow transactions send './transactions/3. Setup USDC.cdc' \
--signer testnet-account \
--network testnet \
--args-json '[]'
```

## 4. Transfer Token

### 4.1. Arguments

```js
to: Address
amount: UFix64
vaultPath: StoragePath
receiverPath: PublicPath
```

- `to`: The recipient address
- `amount`: The amount of token to transfer
- `vaultPath`: The Vault Capability's path of the token
- `receiverPath`: The Receiver Capability's path of the token

### 4.2. Flow-CLI command line

```bash
flow transactions send './cadence/transactions/tokens/3. Transfer Token.cdc' \
  --signer testnet-account \
  --network testnet \
  --args-json '[
    { "type": "Address", "value": "0xd84327a2b08fd2b1" },
    { "type": "UFix64", "value": "0.1" },
    {
      "type": "Path",
      "value": { "domain": "storage", "identifier": "usdcVault" }
    },
    {
      "type": "Path",
      "value": { "domain": "public", "identifier": "usdcReceiver" }
    }
  ]'
```

# III. Scripts

## 1. Get Accounts

### 1.1. Arguments

```js
publicKey: String
signatureAlgorithm: UInt8
hashAlgorithm: UInt8
```

- `publicKey`: Public key of the account as a hexadecimal string
- `signatureAlgorithm`: Signature algorithm for `PublicKey` as raw data

| Algorithm | Raw data |
| --------- | -------- |
| ECDSA_P256 | 1 |
| ECDSA_secp256k1 | 2 |
| BLS_BLS12_381 | 3 |

> **Note**: New Cadence `enum` type has raw data starting from `0` instead of `1`. \
> Thus, it would be increased/decreased by 1 in the code logic to avoid mismatching for `Factory.PubKey`.

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
> Thus, it would be increased/decreased by 1 in the code logic to avoid mismatching for `Factory.Key`.

### 1.2. Flow-CLI command line

```bash
flow scripts execute './scripts/1. Get Accounts.cdc' \
--network testnet \
--args-json '[
  {
    "type": "String",
    "value": "2ca8f4e4d35917a25f909f738b114201468b2ea0b60ebe2cdd9b6ed3eb25717340e12ac97fbf4efa66f3f45f4673127c9d9f717e40ee4c0aac1dea42ae9db3e4"
  },
  { "type": "UInt8", "value": "1" },
  { "type": "UInt8", "value": "1" }
]'
```

## 2. Get balances

### 2.1. Arguments

```js
address: Address
balancePaths: [PublicPath]
```

- `address`: The account address we want to inspect
- `balancePaths`: An `PublicPath` array of token's balance paths we want to get balances. If the array size is `0`, all token balances available in the account is returned.

### 2.2. Flow-CLI command line

```bash
flow scripts execute './scripts/2. Get Balances.cdc' \
--network testnet \
--args-json '[
  { "type": "Address", "value": "0xd84327a2b08fd2b1" },
  {
    "type": "Array",
    "value": [
      {
        "type": "Path",
        "value": { "domain": "public", "identifier": "flowTokenBalance" }
      },
      {
        "type": "Path",
        "value": { "domain": "public", "identifier": "aspBalance" }
      }
    ]
  }
]'
```

## 3. Check setup

### 3.1. Arguments

```js
address: Address
receiverPath: [PublicPath]
```

- `address`: The account address we want to inspect
- `receiverPath`: An `PublicPath` array of token's receiver paths we want to check.

### 3.2. Flow-CLI command line

```bash
flow scripts execute './scripts/3. Check Setup.cdc' \
--network testnet \
--args-json '[
  { "type": "Address", "value": "0xd84327a2b08fd2b1" },
  {
    "type": "Array",
    "value": [
      {
        "type": "Path",
        "value": { "domain": "public", "identifier": "flowTokenReceiver" }
      },
      {
        "type": "Path",
        "value": { "domain": "public", "identifier": "fusdReceiver" }
      }
    ]
  }
]'
```
