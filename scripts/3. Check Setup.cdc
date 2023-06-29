import FungibleToken from "FungibleToken"

access(all) fun main(addr: Address, paths: [StoragePath]): {String: Bool} {
    let res: {String: Bool} = {}
    for path in paths {
        let receiverRef: &FungibleToken.Vault{FungibleToken.Receiver}? = getAccount(addr)
            .getCapability(/public/fusdReceiver)
            .borrow<&FungibleToken.Vault{FungibleToken.Receiver}>()
            ?? nil

        let balanceRef: &FungibleToken.Vault{FungibleToken.Balance}? = getAccount(addr)
            .getCapability(/public/fusdBalance)
            .borrow<&FungibleToken.Vault{FungibleToken.Balance}>()
            ?? nil

        res.insert(key: path.toString(), receiverRef != nil && balanceRef != nil)
    }

    return res
}