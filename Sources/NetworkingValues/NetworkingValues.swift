import Foundation

/// A collection of values used to make and handle network requests.
public struct NetworkingValues {
    public var method: Method
    public var components: URLComponents
    public var headers: [HeaderField: String]
    public var body: Body?
    
    private var context = [ObjectIdentifier: Any]()
    
    public init(_ method: Method = .get, components: URLComponents = .init(), headers: [HeaderField: String] = [:], body: Body? = nil) {
        self.method = method
        self.components = components
        self.headers = headers
        self.body = body
    }
    
    public subscript<Key: NetworkingKey>(key: Key.Type) -> Key.Value {
        get { context[ObjectIdentifier(key)] as? Key.Value ?? Key.defaultValue }
        set { context[ObjectIdentifier(key)] = newValue }
    }
}


public extension NetworkingValues {
    
    /// An enumeration defining the possible methods used to make HTTP requests.
    enum Method: String, Hashable {
        case get, head, post, put, delete, connect, options, trace
    }
    
    /// An enumeration defining the possible ways data can be provided for an HTTP request body.
    enum Body: Equatable {
        case raw(Data)
        case stream(InputStream)
    }
    
    /// A case insensitive header field used to make HTTP requests.
    struct HeaderField: Hashable {
        public static let accept: Self = "Accept"
        public static let acceptCharset: Self = "Accept-Charset"
        public static let acceptEncoding: Self = "Accept-Encoding"
        public static let acceptLanguage: Self = "Accept-Language"
        public static let acceptRanges: Self = "Accept-Ranges"
        public static let age: Self = "Age"
        public static let allow: Self = "Allow"
        public static let authorization: Self = "Authorization"
        public static let cacheControl: Self = "Cache-Control"
        public static let connection: Self = "Connection"
        public static let contentEncoding: Self = "Content-Encoding"
        public static let contentLanguage: Self = "Content-Language"
        public static let contentLength: Self = "Content-Length"
        public static let contentLocation: Self = "Content-Location"
        public static let contentMD5: Self = "Content-MD5"
        public static let contentRange: Self = "Content-Range"
        public static let contentType: Self = "Content-Type"
        public static let date: Self = "Date"
        public static let eTag: Self = "ETag"
        public static let expect: Self = "Expect"
        public static let expires: Self = "Expires"
        public static let from: Self = "From"
        public static let host: Self = "Host"
        public static let ifMatch: Self = "If-Match"
        public static let ifModifiedSince: Self = "If-Modified-Since"
        public static let ifNoneMatch: Self = "If-None-Match"
        public static let ifRange: Self = "If-Range"
        public static let ifUnmodifiedSince: Self = "If-Unmodified-Since"
        public static let lastModified: Self = "Last-Modified"
        public static let location: Self = "Location"
        public static let maxForwards: Self = "Max-Forwards"
        public static let pragma: Self = "Pragma"
        public static let proxyAuthenticate: Self = "Proxy-Authenticate"
        public static let proxyAuthorization: Self = "Proxy-Authorization"
        public static let range: Self = "Range"
        public static let referer: Self = "Referer"
        public static let retryAfter: Self = "Retry-After"
        public static let server: Self = "Server"
        public static let te: Self = "TE"
        public static let trailer: Self = "Trailer"
        public static let transferEncoding: Self = "Transfer-Encoding"
        public static let upgrade: Self = "Upgrade"
        public static let userAgent: Self = "User-Agent"
        public static let vary: Self = "Vary"
        public static let via: Self = "Via"
        public static let warning: Self = "Warning"
        public static let wwwAuthenticate: Self = "WWW-Authenticate"
        
        public let rawValue: String
        
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

extension NetworkingValues.HeaderField: ExpressibleByStringLiteral {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue.compare(rhs.rawValue, options: [.caseInsensitive]) == .orderedSame
    }
    
    public func hash(into hasher: inout Hasher) {
        rawValue.lowercased().hash(into: &hasher)
    }
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
}


public extension URLRequest {
    
    init(values: NetworkingValues) throws {
        guard let url = values.components.url else { throw URLError(.badURL) }
        self.init(url: url)
        httpMethod = values.method.rawValue.uppercased()
        for (field, value) in values.headers {
            addValue(value, forHTTPHeaderField: field.rawValue)
        }
        switch values.body {
        case .raw(let body):
            httpBody = body
        case .stream(let body):
            httpBodyStream = body
        case .none:
            break
        }
    }
}
