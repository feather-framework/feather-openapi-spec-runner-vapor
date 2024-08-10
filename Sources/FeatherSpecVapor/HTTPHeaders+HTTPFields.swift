import HTTPTypes
import Vapor

extension HTTPHeaders {

    /// Converts `HTTPHeaders` to `HTTPFields`.
    ///
    /// This function iterates over the headers and converts each one into an `HTTPField`, which is then appended to an `HTTPFields` collection.
    ///
    /// - Returns: An `HTTPFields` collection containing all the HTTP headers.
    func toHTTPFields() -> HTTPFields {
        var fields = HTTPFields()
        for index in self.indices {
            fields.append(
                HTTPField(
                    name: HTTPField.Name(self[index].name)!,
                    value: self[index].value
                )
            )
        }
        return fields
    }
}
