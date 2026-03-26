extension HTTPClient {
    enum HeaderKey: String {
        case contentType = "Content-Type"
        case acceptEncoding = "Accept-Encoding"
        case authorization = "Authorization"
        case setCookie = "Set-Cookie"
    }
}
