import Fluent
import Vapor

final class StickerDB: Model, Content {
    static let schema = "stickers"

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

final class Sticker: Model, Content {
    static let schema = "stickers"

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "images")
    var images: [String]

    init() { }
    
    init(_ stickerDB: StickerDB) {
        self.id = stickerDB.id
        self.title = stickerDB.title
        self.images = []
    }

    init(id: UUID? = nil, title: String, images: [String] = []) {
        self.id = id
        self.title = title
        self.images = images
    }
}
