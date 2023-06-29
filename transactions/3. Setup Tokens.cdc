import FungibleToken from "FungibleToken"
import Factory from "Factory"
import Token from "Token"

/// @params tokens: [[tokenAddress, contractName, vaultPath, receivefPath, balancePath]]
transaction(tokens: [Token.Full]) {
    prepare(auth: AuthAccount) {
        for i, token in tokens {
            let contractRef: &FungibleToken = getAccount(token.address).contracts.borrow<&FungibleToken>(name: token.contractName)!
            
            if auth.borrow<&FungibleToken.Vault>(from: token.vaultPath) == nil {
                auth.save(<-contractRef.createEmptyVault(), to: token.vaultPath)
                auth.link<&FungibleToken.Vault{FungibleToken.Receiver}>(token.receiverPath, target: token.vaultPath)
                auth.link<&FungibleToken.Vault{FungibleToken.Balance}>(token.balancePath, target: token.vaultPath)
            }
        }


    }
}