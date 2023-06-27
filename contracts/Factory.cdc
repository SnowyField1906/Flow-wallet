import FungibleToken from "FungibleToken"

access(all) contract Factory {
    access(self) let _accounts: {String: [Address]}
    access(self) let _keys: {String: Key}

    access(all) event AccountCreated(address: Address, publicKey: String)

    access(all) enum SignAlgo: UInt8 {
        /// ECDSA_P256 is ECDSA on the NIST P-256 curve.
        access(all) case ECDSA_P256

        /// ECDSA_secp256k1 is ECDSA on the secp256k1 curve.
        access(all) case ECDSA_secp256k1

        /// BLS_BLS12_381 is BLS signature scheme on the BLS12-381 curve.
        /// The scheme is set-up so that signatures are in G_1 (subgroup of the curve over the prime field)
        /// while public keys are in G_2 (subgroup of the curve over the prime field extension).
        access(all) case BLS_BLS12_381
    }

    access(all) enum HashAlgo: UInt8 {
        /// SHA2_256 is SHA-2 with a 256-bit digest (also referred to as SHA256).
        access(all) case SHA2_256

        /// SHA2_384 is SHA-2 with a 384-bit digest (also referred to as  SHA384).
        access(all) case SHA2_384

        /// SHA3_256 is SHA-3 with a 256-bit digest.
        access(all) case SHA3_256

        /// SHA3_384 is SHA-3 with a 384-bit digest.
        access(all) case SHA3_384

        /// KMAC128_BLS_BLS12_381 is an instance of KECCAK Message Authentication Code (KMAC128) mac algorithm.
        /// Although this is a MAC algorithm, KMAC is included in this list as it can be used hash
        /// when the key is used a non-public customizer.
        /// KMAC128_BLS_BLS12_381 is used in particular as the hashing algorithm for the BLS signature scheme on the curve BLS12-381.
        /// It is a customized version of KMAC128 that is compatible with the hashing to curve
        /// used in BLS signatures.
        /// It is the same hasher used by signatures in the internal Flow protocol.
        access(all) case KMAC128_BLS_BLS12_381

        /// KECCAK_256 is the legacy Keccak algorithm with a 256-bits digest, as per the original submission to the NIST SHA3 competition.
        /// KECCAK_256 is different than SHA3 and is used by Ethereum.
        access(all) case KECCAK_256
    }

    access(all) struct PubKey {
        access(all) let publicKey: [UInt8]
        access(all) let signAlgo: SignAlgo

        view access(all) fun toBytes(): [UInt8] {
            let b: [UInt8] = self.publicKey
            b.appendAll(self.signAlgo.rawValue.toBigEndianBytes())
            
            return b
        }

        init(publicKey: [UInt8], signAlgo: SignAlgo) {
            self.publicKey = publicKey
            self.signAlgo = signAlgo
        }
    }

    access(all) struct Key {
        access(all) let keyIndex: Int
        access(all) let pubKey: PubKey
        access(all) let hashAlgo: HashAlgo
        access(all) let weight: UFix64
        access(all) let isRevoked: Bool

        view access(all) fun toBytes(): [UInt8] {
            let b: [UInt8] = self.pubKey.toBytes()
            // b.appendAll(self.keyIndex.toBigEndianBytes())
            b.appendAll(self.hashAlgo.rawValue.toBigEndianBytes())
            // b.appendAll(self.weight.toBigEndianBytes())
            // b.appendAll(self.isRevoked ? [1] : [0])

            return b
        }

        view access(all) fun hash(): String {
            let b: [UInt8] = self.toBytes()
            let hash: String = String.encodeHex(HashAlgorithm.KECCAK_256.hash(b))
            return hash
        }

        init(keyIndex: Int, pubKey: PubKey, hashAlgo: HashAlgo, weight: UFix64, isRevoked: Bool) {
            self.keyIndex = keyIndex
            self.pubKey = pubKey
            self.hashAlgo = hashAlgo
            self.weight = weight
            self.isRevoked = isRevoked
        }
    }

    view access(self) fun _downcastSignatureAlgorithm(signatureAlgorithm: SignatureAlgorithm): SignAlgo {
        let signAlgo: SignAlgo = SignAlgo(rawValue: signatureAlgorithm.rawValue - 1)
            ?? panic("Factory: unsupported signature algorithm")
        return signAlgo
    }
    view access(self) fun _downcastHashAlgorithm(hashAlgorithm: HashAlgorithm): HashAlgo {
        let hashAlgo: HashAlgo = HashAlgo(rawValue: hashAlgorithm.rawValue - 1)
            ?? panic("Factory: unsupported hash algorithm")
        return hashAlgo
    }
    view access(self) fun _downcastPublicKey(publicKey: PublicKey): PubKey {
        let signAlgo: SignAlgo = self._downcastSignatureAlgorithm(signatureAlgorithm: publicKey.signatureAlgorithm)

        let pubKey: PubKey = PubKey(
            publicKey: publicKey.publicKey,
            signAlgo: signAlgo
        )
        return pubKey
    }

    view access(self) fun _downcastAccountKey(accountKey: AccountKey): Key {
        let pubKey: PubKey = self._downcastPublicKey(publicKey: accountKey.publicKey)
        let hashAlgo: HashAlgo = self._downcastHashAlgorithm(hashAlgorithm: accountKey.hashAlgorithm)

        let key: Key =  Key(
            keyIndex: accountKey.keyIndex,
            pubKey: pubKey,
            hashAlgo: hashAlgo,
            weight: accountKey.weight,
            isRevoked: accountKey.isRevoked
        )
        return key
    }

    view access(all) fun hashKey(publicKey: PublicKey, hashAlgorithm: HashAlgorithm): String {
        let b: [UInt8] = self._downcastPublicKey(publicKey: publicKey).toBytes()
        b.appendAll(self._downcastHashAlgorithm(hashAlgorithm: hashAlgorithm).rawValue.toBigEndianBytes())

        let hash: String = String.encodeHex(HashAlgorithm.KECCAK_256.hash(b))
        return hash
    }

    ////

    access(self) fun _insert(key: Key, addr: Address) {
        let hash: String = key.hash()

        if self._accounts.containsKey(hash) {
            assert(!self._accounts[hash]!.contains(addr), message: "Factory: account already exists")

            self._accounts[hash]!.append(addr)
        } else {
            self._accounts[hash] = [addr]
        }

        self._keys.insert(key: hash, key)
    }

    access(all) fun createAccount(publicKey: PublicKey, hashAlgo: HashAlgorithm, creationFeeVault: @FungibleToken.Vault) {
        pre {
            creationFeeVault.balance >= 0.001: "Factory: insufficient account creation fee"
        }

        /// Deposit account creation fee into factory account, which then acts as payer of account creation
        self.account.getCapability(/public/flowTokenReceiver).borrow<&{FungibleToken.Receiver}>()!.deposit(from: <-creationFeeVault)

        let pairAccount: AuthAccount = AuthAccount(payer: self.account)

        let accountKey: AccountKey = pairAccount.keys.add(
            publicKey: publicKey,
            hashAlgorithm: hashAlgo,
            weight: 1000.0
        )

        let storableKey: Key = self._downcastAccountKey(accountKey: accountKey)
        let hash: String = storableKey.hash()

        self._insert(key: storableKey, addr: pairAccount.address)

        emit AccountCreated(address: pairAccount.address, publicKey: String.encodeHex(storableKey.pubKey.publicKey))
    }

    view access(all) fun getAccounts(publicKey: PublicKey, hashAlgorithm: HashAlgorithm): [Address] {
        let hash: String = self.hashKey(publicKey: publicKey, hashAlgorithm: hashAlgorithm)
        assert(self._accounts.containsKey(hash), message: "Factory: account does not exist")

        return self._accounts[hash]!
    }

    init() {
        self._accounts = {}
        self._keys = {}
    }
}