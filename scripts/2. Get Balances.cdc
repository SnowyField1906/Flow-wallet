import FungibleToken from "FungibleToken"

access(all) fun main(address: Address, balancePaths: [PublicPath]): {String: UFix64} {
    let balances: {String: UFix64} = {}

    if balancePaths.length == 0 {
        getAccount(address).forEachPublic(fun (path: PublicPath, type: Type): Bool {
            let typeIden: String = type.identifier

            if typeIden.slice(from: typeIden.length - 23, upTo: typeIden.length - 2) == "FungibleToken.Balance" {
                let balanceRef: &AnyResource{FungibleToken.Balance} = getAccount(address)
                    .getCapability<&AnyResource{FungibleToken.Balance}>(path)
                    .borrow() ?? panic("Could not borrow balance reference")
                
                let pathStr: String = path.toString()
                balances.insert(key: pathStr.slice(from: 8, upTo: pathStr.length), balanceRef.balance)
            }

            return true
        })
    } else {
        for balancePath in balancePaths {
            let ref: &AnyResource{FungibleToken.Balance} = getAccount(address)
                .getCapability<&{FungibleToken.Balance}>(balancePath).borrow() ?? panic("Could not borrow balance reference")

            balances.insert(key: balancePath.toString(), ref.balance)
        }
    }

    return balances
}