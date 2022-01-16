import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "Funstick"
    }
    
    app.get("stickers") { req async throws -> [Sticker] in
        let stickers = try await StickerDB.query(on: req.db).all()
        return stickers.map { sticker in
            let sticker = Sticker(sticker)
            if let id = sticker.id?.uuidString {
                let fm = FileManager.default
                let path = app.directory.publicDirectory.appending(id)
                
                if let items = try? fm.contentsOfDirectory(atPath: path) {
                    for item in items {
                        if !item.contains("DS_Store") {
                            sticker.images.append("/\(id)/\(item)")                            
                        }
                    }
                }
            }
            return sticker
        }
    }
    
    app.post("sticker") { req async throws -> Sticker in
        let sticker = try req.content.decode(Sticker.self)
        try await sticker.create(on: req.db)
        return sticker
    }

//    try app.register(collection: StickerController())
}
