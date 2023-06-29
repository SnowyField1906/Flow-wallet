import FungibleToken from "FungibleToken"
import Token from "Token"

access(all) fun main(addr: Address, receiverPath: [PublicPath]): {String: Bool} {
    let res: {String: Bool} = {}
    for path in receiverPath {
        let receiverRef: &AnyResource{FungibleToken.Receiver}? = getAccount(addr)
            .capabilities
            .get<&AnyResource{FungibleToken.Receiver}>(path)
            ?.borrow()
            ?? nil

        // let balanceRef: &AnyResource{FungibleToken.Balance}? = getAccount(addr)
        //     .capabilities
        //     .get(path.balancePath)
        //     .borrow<&AnyResource{FungibleToken.Balance}>()
        //     ?? nil

        let pathIden: String = Token.parseString(path: path)
        res.insert(key: pathIden, receiverRef != nil)
    }

    return res
}