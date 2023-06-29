import FungibleToken from "FungibleToken"
import FUSD from 0xe223d8a629e49c68
import FiatToken from 0xa983fecbed621163

transaction() {
    prepare(auth: AuthAccount) {
        if auth.borrow<&FUSD.Vault>(from: /storage/fusdVault) == nil {
            auth.save(<-FUSD.createEmptyVault(), to: /storage/fusdVault)
            auth.link<&FUSD.Vault{FungibleToken.Receiver}>(/public/fusdReceiver, target: /storage/fusdVault)
            auth.link<&FUSD.Vault{FungibleToken.Balance}>(/public/fusdBalance, target: /storage/fusdVault)
        }

        if auth.borrow<&FiatToken.Vault>(from: FiatToken.VaultStoragePath) != nil {
            auth.save(<-FiatToken.createEmptyVault(), to: FiatToken.VaultStoragePath)
            auth.link<&FiatToken.Vault{FungibleToken.Receiver}>( FiatToken.VaultReceiverPubPath, target: FiatToken.VaultStoragePath)
            auth.link<&FiatToken.Vault{FiatToken.ResourceId}>(FiatToken.VaultUUIDPubPath, target: FiatToken.VaultStoragePath)
            auth.link<&FiatToken.Vault{FungibleToken.Balance}>(FiatToken.VaultBalancePubPath, target: FiatToken.VaultStoragePath)
        }
    }
}
 