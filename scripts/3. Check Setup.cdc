import FungibleToken from "FungibleToken"
import TokenInfo from "TokenInfo"

access(all) fun main(addr: Address, receiverPath: [PublicPath]): {String: Bool} {
    let res: {String: Bool} = {}
    for path in receiverPath {
        let receiverRef: &AnyResource{FungibleToken.Receiver}? = getAccount(addr)
            .getCapability<&AnyResource{FungibleToken.Receiver}>(path)
            .borrow()
            ?? nil

        // let balanceRef: &AnyResource{FungibleToken.Balance}? = getAccount(addr)
        //     .getCapability(path.balancePath)
        //     .borrow<&AnyResource{FungibleToken.Balance}>()
        //     ?? nil

        let pathIden: String = TokenInfo.parseString(path: path)
        res.insert(key: pathIden, receiverRef != nil)
    }

    return res
}