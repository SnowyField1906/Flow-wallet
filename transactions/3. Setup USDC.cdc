import FungibleToken from "FungibleToken"
import FiatToken from "FiatToken"

transaction() {
    prepare(auth: AuthAccount) {
        if auth.borrow<&FiatToken.Vault>(from: FiatToken.VaultStoragePath) != nil {
            auth.save(<-FiatToken.createEmptyVault(), to: FiatToken.VaultStoragePath)
            auth.link<&FiatToken.Vault{FungibleToken.Receiver}>( FiatToken.VaultReceiverPubPath, target: FiatToken.VaultStoragePath)
            auth.link<&FiatToken.Vault{FiatToken.ResourceId}>(FiatToken.VaultUUIDPubPath, target: FiatToken.VaultStoragePath)
            auth.link<&FiatToken.Vault{FungibleToken.Balance}>(FiatToken.VaultBalancePubPath, target: FiatToken.VaultStoragePath)
        }
    }
}