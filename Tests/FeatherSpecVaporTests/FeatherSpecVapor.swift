import XCTest
import OpenAPIRuntime
import FeatherSpec
import Vapor
import FeatherSpecVapor

final class FeatherSpecVaporTests: XCTestCase {

    let todo = Todo(title: "task01")
    let body = Todo(title: "task01").httpBody

    func todosApp() async throws -> Application {
        let app = try await Application.make(.testing)
        app.routes.post("todos") { req async throws -> Todo in
            try req.content.decode(Todo.self)
        }
        return app
    }

    func testMutatingfuncSpec() async throws {
        let app = try await todosApp()
        let runner = VaporSpecRunner(app: app)

        var spec = Spec()
        spec.setMethod(.post)
        spec.setPath("todos")
        spec.setBody(todo.httpBody)
        spec.setHeader(.contentType, "application/json")
        spec.addExpectation(.ok)
        spec.addExpectation { response, body in
            let todo = try await body.decode(Todo.self, with: response)
            XCTAssertEqual(todo.title, self.todo.title)
        }

        try await runner.run(spec)
        try await app.asyncShutdown()
    }

    func testBuilderFuncSpec() async throws {
        let app = try await todosApp()
        let runner = VaporSpecRunner(app: app)

        let spec = Spec()
            .post("todos")
            .header(.contentType, "application/json")
            .body(body)
            .expect(.ok)
            .expect { response, body in
                let todo = try await body.decode(Todo.self, with: response)
                XCTAssertEqual(todo.title, "task01")
            }

        try await runner.run(spec)
        try await app.asyncShutdown()
    }

    func testDslSpec() async throws {
        let app = try await todosApp()
        let runner = VaporSpecRunner(app: app)

        let spec = SpecBuilder {
            Method(.post)
            Path("todos")
            Header(.contentType, "application/json")
            Body(body)
            Expect(.ok)
            Expect { response, body in
                let todo = try await body.decode(Todo.self, with: response)
                XCTAssertEqual(todo.title, "task01")
            }
        }
        .build()

        try await runner.run(spec)
        try await app.asyncShutdown()
    }

    func testNoPath() async throws {
        let app = try await Application.make(.testing)
        let runner = VaporSpecRunner(app: app)

        try await runner.run {
            Method(.get)
        }
        try await app.asyncShutdown()
    }

    func testUnkownLength() async throws {
        let app = try await todosApp()
        let runner = VaporSpecRunner(app: app)

        let sequence = AnySequence(#"{"title":"task01"}"#.utf8)
        let body = HTTPBody(
            sequence,
            length: .unknown,
            iterationBehavior: .single
        )

        try await runner.run {
            Method(.post)
            Path("todos")
            Header(.contentType, "application/json")
            Body(body)
            Expect(.ok)
            Expect { response, body in
                let todo = try await body.decode(Todo.self, with: response)
                XCTAssertEqual(todo.title, "task01")
            }
        }
        try await app.asyncShutdown()
    }
}
