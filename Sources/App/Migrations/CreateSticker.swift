import Fluent

struct CreateSticker: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("stickers")
            .id()
            .field("title", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("stickers").delete()
    }
}
