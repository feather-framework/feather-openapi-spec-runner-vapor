import Vapor
import OpenAPIRuntime

struct Todo: Codable {
    let title: String
}

extension Todo: Content {}

extension Todo {

    var httpBody: HTTPBody {
        let encoder = JSONEncoder()
        var buffer = ByteBuffer()
        try! encoder.encode(self, into: &buffer)
        return HTTPBody(.init(buffer: buffer))
    }
}
