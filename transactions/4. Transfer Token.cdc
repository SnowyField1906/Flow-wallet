import FungibleToken from "FungibleToken"

transaction(to: Address, amount: UFix64, vaultPath: StoragePath, receiverPath: PublicPath) {
    let vault: @FungibleToken.Vault
    let receiverRef: &AnyResource{FungibleToken.Receiver}

    prepare(auth: AuthAccount) {
        self.vault <- auth.borrow<&FungibleToken.Vault>(from: vaultPath)
            ?.withdraw(amount: amount)
            ?? panic("Transaction: Could not withdraw tokens from vault")

        self.receiverRef = getAccount(to)
            .capabilities
            .get<&AnyResource{FungibleToken.Receiver}>(receiverPath)
            ?.borrow()!
            ?? panic("Transaction: Could not borrow receiver reference")
    }

    execute {
        self.receiverRef.deposit(from: <- self.vault)
    }
}
 