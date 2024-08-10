import HTTPTypes
import NIOHTTP1

extension HTTPTypes.HTTPFields {

    /// Initializes `HTTPFields` from `NIOHTTP1.HTTPHeaders`.
    ///
    /// This initializer converts each header from `NIOHTTP1.HTTPHeaders` to `HTTPField` and appends it to `HTTPFields`.
    ///
    /// - Parameter headers: The `NIOHTTP1.HTTPHeaders` to be converted.
    init(_ headers: NIOHTTP1.HTTPHeaders) {
        self.init(
            headers.compactMap { name, value in
                guard let name = HTTPField.Name(name) else {
                    return nil
                }
                return HTTPField(name: name, value: value)
            }
        )
    }
}

extension NIOHTTP1.HTTPHeaders {

    /// Initializes `HTTPHeaders` from `HTTPTypes.HTTPFields`.
    ///
    /// This initializer converts each `HTTPField` from `HTTPFields` to a tuple and initializes `NIOHTTP1.HTTPHeaders`.
    ///
    /// - Parameter headers: The `HTTPTypes.HTTPFields` to be converted.
    init(_ headers: HTTPTypes.HTTPFields) {
        self.init(headers.map { ($0.name.rawName, $0.value) })
    }
}

extension NIOHTTP1.HTTPMethod {

    /// Initializes `HTTPMethod` from `HTTPTypes.HTTPRequest.Method`.
    ///
    /// This initializer maps each `HTTPRequest.Method` to the corresponding `NIOHTTP1.HTTPMethod`.
    ///
    /// - Parameter method: The `HTTPTypes.HTTPRequest.Method` to be converted.
    init(_ method: HTTPTypes.HTTPRequest.Method) {
        switch method {
        case .get: self = .GET
        case .put: self = .PUT
        case .post: self = .POST
        case .delete: self = .DELETE
        case .options: self = .OPTIONS
        case .head: self = .HEAD
        case .patch: self = .PATCH
        case .trace: self = .TRACE
        default: self = .RAW(value: method.rawValue)
        }
    }
}
