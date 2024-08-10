import OpenAPIRuntime
import HTTPTypes
import FeatherSpec
import XCTVapor

/// A struct that conforms to the `SpecExecutor` protocol and executes HTTP requests using Vapor.
///
/// This executor uses an `XCTApplicationTester` to perform the actual HTTP request execution and handles
/// the response and body transformations.
struct VaporSpecExecutor: SpecExecutor {

    /// The client responsible for executing HTTP requests.
    let client: XCTApplicationTester

    /// Executes an HTTP request with the provided request and body.
    ///
    /// This function collects the body data, constructs the request URI, and uses the client to execute the request.
    /// It transforms the client response into an `HTTPResponse` and `HTTPBody`.
    ///
    /// - Parameters:
    ///   - req: The HTTP request to be executed.
    ///   - body: The body of the HTTP request.
    ///
    /// - Returns: A tuple containing the HTTP response and the response body.
    ///
    /// - Throws: Rethrows an underlying error.
    public func execute(
        req: HTTPRequest,
        body: HTTPBody
    ) async throws -> (
        response: HTTPResponse,
        body: HTTPBody
    ) {
        let method = HTTPMethod(rawValue: req.method.rawValue)
        let uri = {
            var uri = req.path ?? ""
            if !uri.hasPrefix("/") {
                uri = "/" + uri
            }
            return uri
        }()
        let headers = HTTPHeaders(req.headerFields.toHTTPHeaders())
        let buffer = try await body.collect()

        var result: (response: HTTPResponse, body: HTTPBody)!

        try await client.test(
            method,
            uri,
            headers: headers,
            body: buffer
        ) { res async throws in
            let response = HTTPResponse(
                status: .init(
                    code: Int(res.status.code),
                    reasonPhrase: res.status.reasonPhrase
                ),
                headerFields: .init(res.headers.toHTTPFields())
            )
            let body = HTTPBody(.init(buffer: res.body))
            result = (response: response, body: body)
        }

        return result
    }
}
