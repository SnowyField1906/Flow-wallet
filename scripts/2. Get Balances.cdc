import FungibleToken from "FungibleToken"
import Token from "Token"

access(all) fun main(address: Address, balancePaths: [PublicPath]): {String: UFix64} {
    let balances: {String: UFix64} = {}

    if balancePaths.length == 0 {
        getAccount(address).forEachPublic(fun (path: PublicPath, type: Type): Bool {
            let typeIden: String = type.identifier

            if typeIden.slice(from: typeIden.length - 23, upTo: typeIden.length - 2) == "FungibleToken.Balance" {
                let balanceRef: &AnyResource{FungibleToken.Balance} = getAccount(address)
                    .capabilities
                    .get<&AnyResource{FungibleToken.Balance}>(path)
                    ?.borrow()!
                    ?? panic("Script: Could not borrow balance reference")
                
                let pathIden: String = Token.parseString(path: path)
                balances.insert(key: pathIden, balanceRef.balance)
            }

            return true
        })
    } else {
        for balancePath in balancePaths {
            let ref: &AnyResource{FungibleToken.Balance} = getAccount(address)
                .capabilities
                .get<&{FungibleToken.Balance}>(balancePath)
                ?.borrow()!
                ?? panic("Script: Could not borrow balance reference")
    
            let pathIden: String = Token.parseString(path: balancePath)
            balances.insert(key: pathIden, ref.balance)
        }
    }

    return balances
}