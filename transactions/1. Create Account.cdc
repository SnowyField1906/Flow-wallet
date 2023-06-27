import FungibleToken from "FungibleToken"
import Wallet from "Wallet"

transaction(publicKey: String, signatureAlgorithm: UInt8, hashAlgorithm: UInt8, creationFee: UFix64) {
    let creationFeeVault: @FungibleToken.Vault
    let _publicKey: PublicKey
    let _hashAlgorithm: HashAlgorithm

    prepare(auth: AuthAccount) {
        let _signatureAlgorithm: SignatureAlgorithm = SignatureAlgorithm(signatureAlgorithm + 1)
            ?? panic("Invalid signature raw value")
            
        self._publicKey = PublicKey(
            publicKey: publicKey.decodeHex(),
            signatureAlgorithm: _signatureAlgorithm
        )
        self._hashAlgorithm = HashAlgorithm(hashAlgorithm + 1) ?? panic("Invalid hash raw value")

        self.creationFeeVault <- auth.borrow<&FungibleToken.Vault>(from: /storage/flowTokenVault)
            ?.withdraw(amount: creationFee)
            ?? panic("Could not to withdraw creation fee")
    }

    pre {
        self.creationFeeVault.balance >= 0.001: "insufficient account creation fee"
    }

    execute {
        Wallet.createAccount(
            publicKey: self._publicKey,
            hashAlgo: self._hashAlgorithm,
            creationFeeVault: <- self.creationFeeVault
        )
    }
}