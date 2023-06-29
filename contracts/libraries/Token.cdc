import FungibleToken from "FungibleToken"

access(all) contract Token {
    access(all) struct Full {
        access(all) let identifier: Identifier;
        access(all) let paths: Paths;

        init(identifier: Identifier, paths: Paths) {
            self.identifier = identifier
            self.paths = paths
        }
    }

    access(all) struct Identifier {
        access(all) let address: Address;
        access(all) let contractName: String;

        init(address: Address, contractName: String) {
            self.address = address
            self.contractName = contractName
        }
    }

    access(all) struct Paths {
        access(all) let vaultPath: StoragePath;
        access(all) let receiverPath: PublicPath;
        access(all) let balancePath: PublicPath;

        init(vaultPath: StoragePath, receiverPath: PublicPath, balancePath: PublicPath) {
            self.vaultPath = vaultPath
            self.receiverPath = receiverPath
            self.balancePath = balancePath
        }
    }

    access(all) fun parseString(path: AnyStruct): String {
        var publicPath: PublicPath? = path as? PublicPath
        if publicPath != nil {
            let pathStr: String = publicPath!.toString()
            return pathStr.slice(from: 8, upTo: pathStr.length)
        }
        var storagePath: StoragePath? = path as? StoragePath
        if storagePath != nil {
            let pathStr: String = storagePath!.toString()
            return pathStr.slice(from: 9, upTo: pathStr.length)
        }

        panic("Invalid path type")
    }

    // access(all) fun parseString(path: PublicPath): String {
    //     let pathStr: String = path.toString()
    //     return pathStr.slice(from: 8, upTo: pathStr.length)
    // }

}