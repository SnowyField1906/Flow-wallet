import Wallet from "Wallet"

access(all) fun main(addr: Address): Wallet.Key {
    let key: Wallet.Key = Wallet.get(addr: addr)
    return key
}