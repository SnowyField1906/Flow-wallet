import FungibleToken from "FungibleToken"
import FUSD from "FUSD"
import FiatToken from "FiatToken"

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
 