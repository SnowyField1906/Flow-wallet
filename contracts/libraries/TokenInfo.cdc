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
}