import Wallet from "Wallet"

access(all) fun main(publicKey: String, signatureAlgorithm: UInt8, hashAlgorithm: UInt8): [Address] {
    let signatureAlgorithm: SignatureAlgorithm = SignatureAlgorithm(signatureAlgorithm + 1)
        ?? panic("Invalid signature raw value")
    let publicKey: PublicKey = PublicKey(
            publicKey: publicKey.decodeHex(),
            signatureAlgorithm: signatureAlgorithm
        )
    let hashAlgorithm: HashAlgorithm = HashAlgorithm(hashAlgorithm + 1)
        ?? panic("Invalid hash raw value")

    let accounts: [Address] = Wallet.getAccounts(publicKey: publicKey, hashAlgorithm: hashAlgorithm)

    return accounts
}