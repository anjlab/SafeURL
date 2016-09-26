import Foundation

// Creates URLPathSegmentAllowedCharacterSet same as URLPathAllowedCharacterSet - "/"
private func _createURLPathSegmentAllowedCharacterSet() -> CharacterSet {
    let pathSegmentCharacterSet = (CharacterSet.urlPathAllowed as NSCharacterSet)
        .mutableCopy() as! NSMutableCharacterSet
    
    pathSegmentCharacterSet.removeCharacters(in: "/")
    
    return pathSegmentCharacterSet as CharacterSet
}

// Global var with URLPathSegmentAllowedCharacterSet to reduce
private let _URLPathSegmentAllowedCharacterSet = _createURLPathSegmentAllowedCharacterSet()

private func _pathSegmentsToPath(_ segments: [Any]?) -> String? {
    guard let segments = segments else { return nil }
    
    return segments.map {
        "\($0)"
            .addingPercentEncoding(withAllowedCharacters: _URLPathSegmentAllowedCharacterSet)
            ?? "\($0)"
        }.joined(separator: "/")
}

// Encode complex key/value objects in NSRULQueryItem pairs
private func _queryItems(_ key: String, _ value: Any?) -> [URLQueryItem] {
    var result = [] as [URLQueryItem]
   
    if let dictionary = value as? [String: AnyObject] {
        for (nestedKey, value) in dictionary {
            result += _queryItems("\(key)[\(nestedKey)]", value)
        }
    } else if let array = value as? [AnyObject] {
        let arrKey = key + "[]"
        for value in array {
            result += _queryItems(arrKey, value)
        }
    } else if let _ = value as? NSNull {
        result.append(URLQueryItem(name: key, value: nil))
    } else if let v = value {
        result.append(URLQueryItem(name: key, value: "\(v)"))
    } else {
        result.append(URLQueryItem(name: key, value: nil))
    }
    
    return result
}

// Encodes complex [String: AnyObject] params into array of NSURLQueryItem
private func _paramsToQueryItems(_ params: [String: Any]?) -> [URLQueryItem]? {
    guard let params = params else { return nil }
    
    var result = [] as [URLQueryItem]
   
    for (key, value) in params {
        result += _queryItems(key, value)
    }
    return result.sorted(by: { $0.name < $1.name })
}


public extension URLComponents {
    
    // MARK: path as String
    
    @nonobjc
    init(path: String, query: String?, fragment: String? = nil) {
        self.init()
        
        self.path     = path
        self.query    = query
        self.fragment = fragment
    }
    
    @nonobjc
    init(path: String, queryItems: [URLQueryItem]?, fragment: String? = nil) {
        self.init()
        
        self.path       = path
        self.queryItems = queryItems
        self.fragment   = fragment
    }
    
    @nonobjc
    init(path: String, query: [String: Any]?, fragment: String? = nil) {
        self.init()
        
        self.path       = path
        self.queryItems = _paramsToQueryItems(query)
        self.fragment   = fragment
    }
   
    // MARK: path as array of segments
    
    @nonobjc
    init(path segments: [Any]?, query: String?, fragment: String? = nil) {
        self.init()
        
        if let encodedPath = _pathSegmentsToPath(segments) {
            self.percentEncodedPath = encodedPath
        }
        self.query              = query
        self.fragment           = fragment
    }
   
    @nonobjc
    init(path segments: [Any]?, query: [String: Any]?, fragment: String? = nil) {
        self.init()
        
        if let encodedPath = _pathSegmentsToPath(segments) {
            self.percentEncodedPath = encodedPath
        }
        self.queryItems         = _paramsToQueryItems(query)
        self.fragment           = fragment
    }
}

public extension URL {
    
    static func build(_ baseURL: URL? = nil, components: URLComponents) -> URL? {
        return components.url(relativeTo: baseURL)?.absoluteURL
    }
    
    
    func build(_ components: URLComponents) -> URL? {
        return components.url(relativeTo: self)?.absoluteURL
    }
    
    
    
    static func build(_ baseURL: URL? = nil, path: String,  query: String, fragment: String? = nil) -> URL? {
        return build(baseURL, components: URLComponents(path: path, query: query, fragment: fragment))
    }
    
    
    func build(_ path: String, query: String, fragment: String? = nil) -> URL? {
        return build(URLComponents(path: path, query: query, fragment: fragment))
    }
    
    
    static func build(_ baseURL: URL? = nil, path: String,  query: [String: Any]? = nil, fragment: String? = nil) -> URL? {
        return build(baseURL, components: URLComponents(path: path, query: query, fragment: fragment))
    }

    
    func build(_ path: String, query: [String: Any]? = nil, fragment: String? = nil) -> URL? {
        return build(URLComponents(path: path, query: query, fragment: fragment))
    }

    
    static func build(_ baseURL: URL? = nil, path: [Any]? = nil, query: String, fragment: String? = nil) -> URL? {
        return build(baseURL, components: URLComponents(path: path, query: query, fragment: fragment))
    }
    
    
    func build(_ path: [Any]? = nil, query: String, fragment: String? = nil) -> URL? {
        return build(URLComponents(path: path, query: query, fragment: fragment))
    }
    
    
    static func build(_ baseURL: URL? = nil, path: [Any]? = nil,  query: [String: Any]? = nil, fragment: String? = nil) -> URL? {
        return build(baseURL, components: URLComponents(path: path, query: query, fragment: fragment))
    }
    
    
    func build(_ path: [Any]? = nil, query: [String: Any]? = nil, fragment: String? = nil) -> URL? {
        return build(URLComponents(path: path, query: query, fragment: fragment))
    }
    
    
    static func build(scheme: String?, host: String? = nil, port: Int? = nil, path: String, query: [String: Any]? = nil, fragment: String? = nil) -> URL? {
        
        var components = URLComponents(path: path, query: query, fragment: fragment)
        
        components.scheme = scheme
        components.host   = host
        components.port   = port
        
        return components.url
    }
    
    
    static func build(scheme: String?, host: String? = nil, port: Int? = nil, path: [Any]? = nil, query: [String: Any]? = nil, fragment: String? = nil) -> URL? {
        
        var components = URLComponents(path: path, query: query, fragment: fragment)
        
        components.scheme = scheme
        components.host   = host
        components.port   = port
        
        return components.url
    }
}
