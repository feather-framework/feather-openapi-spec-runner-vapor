import Vapor
import XCTVapor
import FeatherSpec

/// A struct that conforms to the `SpecRunner` protocol and runs specifications using Vapor.
///
/// This runner initializes with a Vapor application and a testing setup method. It uses the application to perform tests
/// with a provided block that takes a `SpecExecutor`.
public struct VaporSpecRunner: SpecRunner {

    /// The Vapor application used for testing.
    private let app: Application

    /// The method used for setting up the application during testing.
    private let method: Application.Method

    /// Initializes a new instance of `VaporSpecRunner`.
    ///
    /// - Parameters:
    ///   - app: The Vapor application to be used for testing.
    ///   - method: The setup method for the application during testing. Defaults to `.inMemory`.
    public init(
        app: Application,
        testingSetup method: Application.Method = .inMemory
    ) {
        self.app = app
        self.method = method
    }

    /// Runs a test with the provided block.
    ///
    /// This function uses the application to perform a test with the given setup method.
    /// It passes a `VaporSpecExecutor` to the block, which is used to execute HTTP requests within the test.
    ///
    /// - Parameter block: A closure that takes a `SpecExecutor` and performs asynchronous operations.
    ///
    /// - Important: A new server will be spawned for each request when using the `running` testing setup.
    ///
    /// - Throws: Rethrows an underlying error.
    public func test(
        block: @escaping (SpecExecutor) async throws -> Void
    ) async throws {
        // NOTE: A new server will be spawned for each request when using the `running` testing setup.
        try await block(VaporSpecExecutor(client: app.testable(method: method)))
    }
}
