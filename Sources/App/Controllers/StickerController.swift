import Fluent
import Vapor
import CloudKit

struct StickerController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let stickers = routes.grouped("stickers")
        stickers.get(use: index)
        stickers.post(use: create)
        stickers.group(":stickerID") { sticker in
            sticker.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [Sticker] {
        //        return Sticker.query(on: req.db).all()
        let stickers = try await Sticker.query(on: req.db).all()
        
        return stickers.map { sticker in
            if let id = sticker.id?.uuidString {
                let fm = FileManager.default
                let path = "/Public"
                
                if let items = try? fm.contentsOfDirectory(atPath: path) {
                    for item in items {
                        print("Found \(item)")
                    }
                }
            }
            return sticker
        }
    }

    func create(req: Request) throws -> EventLoopFuture<Sticker> {
        let todo = try req.content.decode(Sticker.self)
        return todo.save(on: req.db).map { todo }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Sticker.find(req.parameters.get("stickerID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
