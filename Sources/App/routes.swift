import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "Funstick"
    }
    
    app.get("stickers") { req async throws -> [Sticker] in
        do {
            let stickers = try await StickerDB.query(on: req.db).all()
            return stickers.map { sticker in
                let sticker = Sticker(sticker)
                if let id = sticker.id?.uuidString {
                    let fm = FileManager.default
                    let path = app.directory.publicDirectory.appending(id)
                    req.logger.info(Logger.Message(stringLiteral: path))
                    if let items = try? fm.contentsOfDirectory(atPath: path) {
                        req.logger.info(Logger.Message(stringLiteral: "count: \(items.count)"))
                        for item in items {
                            req.logger.info(Logger.Message(stringLiteral: "item: \(item)"))
                            if !item.contains("DS_Store") {
                                sticker.images.append("/\(id)/\(item)")
                            }
                        }
                    }
                }
                return sticker
            }
        } catch {
            throw Abort(.internalServerError, reason: error.localizedDescription)
        }
    }
    
    app.post("sticker") { req async throws -> Sticker in
        let sticker = try req.content.decode(Sticker.self)
        try await sticker.create(on: req.db)
        return sticker
    }

//    try app.register(collection: StickerController())
}
