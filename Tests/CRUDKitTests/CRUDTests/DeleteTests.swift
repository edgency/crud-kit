@testable import CRUDKit
import XCTVapor

final class DeleteTests: ApplicationXCTestCase {
    func testDeleteWithValidId() throws {
        try routes()
        try seed()

        try app.test(.GET, "/todos/1") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
            XCTAssertContent(Todo.Public.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertTrue($0.isPublic)
            }
        }.test(.DELETE, "/todos/1") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)
        }.test(.GET, "/todos/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
    }
    
    func testDeleteWithInvalidId() throws {
        try routes()
        try seed()

        try app.test(.GET, "/todos") { res in
            XCTAssertContent([Todo.Public].self, res) {
                XCTAssertEqual($0.count, 3)
            }
        }.test(.DELETE, "/todos/10") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "/todos") { res in
            XCTAssertContent([Todo.Public].self, res) {
                XCTAssertEqual($0.count, 3)
            }
        }
    }
}
