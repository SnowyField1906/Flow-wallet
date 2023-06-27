import Factory from "Factory"

access(all) fun main(publicKey: String, signatureAlgorithm: UInt8, hashAlgorithm: UInt8): [Address] {
    let signatureAlgorithm: SignatureAlgorithm = SignatureAlgorithm(signatureAlgorithm)
        ?? panic("Invalid signature raw value")
    let publicKey: PublicKey = PublicKey(
            publicKey: publicKey.decodeHex(),
            signatureAlgorithm: signatureAlgorithm
        )
    let hashAlgorithm: HashAlgorithm = HashAlgorithm(hashAlgorithm)
        ?? panic("Invalid hash raw value")

    let accounts: [Address] = Factory.getAccounts(publicKey: publicKey, hashAlgorithm: hashAlgorithm)

    return accounts
}