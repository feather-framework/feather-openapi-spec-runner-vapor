import HTTPTypes

extension HTTPFields {

    /// Converts `HTTPFields` to an array of tuples representing HTTP headers.
    ///
    /// This function iterates over the fields and converts each one into a tuple containing the header name and value.
    ///
    /// - Returns: An array of tuples where each tuple contains a header name and its corresponding value.
    func toHTTPHeaders() -> [(String, String)] {
        var headers = [(String, String)]()
        for index in self.indices {
            headers.append((self[index].name.rawName, self[index].value))
        }
        return headers
    }
}
