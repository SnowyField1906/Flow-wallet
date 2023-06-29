import FungibleToken from "FungibleToken"

access(all) contract TokenInfo {
    access(all) struct Full: IPublicPaths {
        access(all) let address: Address;
        access(all) let contractName: String;
        access(all) let vaultPath: StoragePath;
        access(all) let receiverPath: PublicPath;
        access(all) let balancePath: PublicPath;

        init(address: Address, contractName: String, vaultPath: StoragePath, receiverPath: PublicPath, balancePath: PublicPath) {
            self.address = address;
            self.contractName = contractName;
            self.vaultPath = vaultPath;
            self.receiverPath = receiverPath;
            self.balancePath = balancePath;
        }
    }

    access(all) struct interface IPublicPaths {
        access(all) let receiverPath: PublicPath;
        access(all) let balancePath: PublicPath;
    }

    access(all) struct PublicPaths: IPublicPaths {
        access(all) let receiverPath: PublicPath;
        access(all) let balancePath: PublicPath;

        init(receiverPath: PublicPath, balancePath: PublicPath) {
            self.receiverPath = receiverPath;
            self.balancePath = balancePath;
        }
    }

    access(all) struct Paths: IPublicPaths {
        access(all) let vaultPath: StoragePath;
        access(all) let receiverPath: PublicPath;
        access(all) let balancePath: PublicPath;

        init(vaultPath: StoragePath, receiverPath: PublicPath, balancePath: PublicPath) {
            self.vaultPath = vaultPath;
            self.receiverPath = receiverPath;
            self.balancePath = balancePath;
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