import Foundation

// Creates URLPathSegmentAllowedCharacterSet same as URLPathAllowedCharacterSet - "/"
private func _createURLPathSegmentAllowedCharacterSet() -> NSCharacterSet {
    let pathSegmentCharacterSet = NSCharacterSet
        .URLPathAllowedCharacterSet()
        .mutableCopy() as! NSMutableCharacterSet
    
    pathSegmentCharacterSet.removeCharactersInString("/")
    
    return pathSegmentCharacterSet
}

// Global var with URLPathSegmentAllowedCharacterSet to reduce
private let _URLPathSegmentAllowedCharacterSet = _createURLPathSegmentAllowedCharacterSet()

private func _pathSegmentsToPath(segments: [AnyObject]?) -> String? {
    guard let segments = segments else { return nil }
    
    return segments.map {
        $0.description
            .stringByAddingPercentEncodingWithAllowedCharacters(_URLPathSegmentAllowedCharacterSet)
            ?? $0.description
        }.joinWithSeparator("/")
}

// Encode complex key/value objects in NSRULQueryItem pairs
private func _queryItems(key: String, _ value: AnyObject?) -> [NSURLQueryItem] {
    var result = [] as [NSURLQueryItem]
   
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
        result.append(NSURLQueryItem(name: key, value: nil))
    } else {
        result.append(NSURLQueryItem(name: key, value: value?.description))
    }
    
    return result
}

// Encodes complex [String: AnyObject] params into array of NSURLQueryItem
private func _paramsToQueryItems(params: [String: AnyObject]?) -> [NSURLQueryItem]? {
    guard let params = params else { return nil }
    
    var result = [] as [NSURLQueryItem]
   
    for (key, value) in params {
        result += _queryItems(key, value)
    }
    return result
}


public extension NSURLComponents {
    
    // MARK: path as String
    
    @nonobjc
    convenience init(path: String, query: String?, fragment: String? = nil) {
        self.init()
        
        self.path     = path
        self.query    = query
        self.fragment = fragment
    }
    
    @nonobjc
    convenience init(path: String, queryItems: [NSURLQueryItem]?, fragment: String? = nil) {
        self.init()
        
        self.path       = path
        self.queryItems = queryItems
        self.fragment   = fragment
    }
    
    @nonobjc
    convenience init(path: String, query: [String: AnyObject]?, fragment: String? = nil) {
        self.init()
        
        self.path       = path
        self.queryItems = _paramsToQueryItems(query)
        self.fragment   = fragment
    }
   
    // MARK: path as array of segments
    
    @nonobjc
    convenience init(path segments: [AnyObject]?, query: String?, fragment: String? = nil) {
        self.init()
        
        self.percentEncodedPath = _pathSegmentsToPath(segments)
        self.query              = query
        self.fragment           = fragment
    }
   
    @nonobjc
    convenience init(path segments: [AnyObject]?, query: [String: AnyObject]?, fragment: String? = nil) {
        self.init()
        
        self.percentEncodedPath = _pathSegmentsToPath(segments)
        self.queryItems         = _paramsToQueryItems(query)
        self.fragment           = fragment
    }
}

public extension NSURL {
    @nonobjc
    static func build(baseURL: NSURL? = nil, components: NSURLComponents) -> NSURL? {
        return components.URLRelativeToURL(baseURL)?.absoluteURL
    }
    
    @nonobjc
    final func build(components: NSURLComponents) -> NSURL? {
        return components.URLRelativeToURL(self)?.absoluteURL
    }
    
    
    @nonobjc
    static func build(baseURL: NSURL? = nil, path: String,  query: String, fragment: String? = nil) -> NSURL? {
        return build(baseURL, components: NSURLComponents(path: path, query: query, fragment: fragment))
    }
    
    @nonobjc
    final func build(path: String, query: String, fragment: String? = nil) -> NSURL? {
        return build(NSURLComponents(path: path, query: query, fragment: fragment))
    }
    
    @nonobjc
    static func build(baseURL: NSURL? = nil, path: String,  query: [String: AnyObject]? = nil, fragment: String? = nil) -> NSURL? {
        return build(baseURL, components: NSURLComponents(path: path, query: query, fragment: fragment))
    }

    @nonobjc
    final func build(path: String, query: [String: AnyObject]? = nil, fragment: String? = nil) -> NSURL? {
        return build(NSURLComponents(path: path, query: query, fragment: fragment))
    }

    @nonobjc
    static func build(baseURL: NSURL? = nil, path: [AnyObject]? = nil, query: String, fragment: String? = nil) -> NSURL? {
        return build(baseURL, components: NSURLComponents(path: path, query: query, fragment: fragment))
    }
    
    @nonobjc
    final func build(path: [AnyObject]? = nil, query: String, fragment: String? = nil) -> NSURL? {
        return build(NSURLComponents(path: path, query: query, fragment: fragment))
    }
    
    @nonobjc
    static func build(baseURL: NSURL? = nil, path: [AnyObject]? = nil,  query: [String: AnyObject]? = nil, fragment: String? = nil) -> NSURL? {
        return build(baseURL, components: NSURLComponents(path: path, query: query, fragment: fragment))
    }
    
    @nonobjc
    final func build(path: [AnyObject]? = nil, query: [String: AnyObject]? = nil, fragment: String? = nil) -> NSURL? {
        return build(NSURLComponents(path: path, query: query, fragment: fragment))
    }
    
    @nonobjc
    static func build(scheme scheme: String?, host: String? = nil, port: UInt? = nil, path: String, query: [String: AnyObject]? = nil, fragment: String? = nil) -> NSURL? {
        
        let components = NSURLComponents(path: path, query: query, fragment: fragment)
        
        components.scheme = scheme
        components.host   = host
        components.port   = port
        
        return components.URL
    }
    
    @nonobjc
    static func build(scheme scheme: String?, host: String? = nil, port: UInt? = nil, path: [AnyObject]? = nil, query: [String: AnyObject]? = nil, fragment: String? = nil) -> NSURL? {
        
        let components = NSURLComponents(path: path, query: query, fragment: fragment)
        
        components.scheme = scheme
        components.host   = host
        components.port   = port
        
        return components.URL
    }
}
