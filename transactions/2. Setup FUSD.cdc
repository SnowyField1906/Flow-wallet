import FungibleToken from "FungibleToken"
import FUSD from "FUSD"

transaction() {
    prepare(auth: AuthAccount) {
        if auth.borrow<&FUSD.Vault>(from: /storage/fusdVault) == nil {
            auth.save(<-FUSD.createEmptyVault(), to: /storage/fusdVault)
            auth.link<&FUSD.Vault{FungibleToken.Receiver}>(/public/fusdReceiver, target: /storage/fusdVault)
            auth.link<&FUSD.Vault{FungibleToken.Balance}>(/public/fusdBalance, target: /storage/fusdVault)
        }
    }
}