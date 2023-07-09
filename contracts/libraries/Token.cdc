import FungibleToken from "FungibleToken"

access(all) contract Token {
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
}