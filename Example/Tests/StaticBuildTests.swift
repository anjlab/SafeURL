//
//  StaticBuildTests.swift
//  SafeURL
//
//  Created by Yury Korolev on 4/2/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import SafeURL

class StaticBuildTests: XCTestCase {
    
    let baseURL = URL(string: "https://some/api/v1/")
    
    func testPath() {
        XCTAssertEqual(
            URL.build(baseURL)?.absoluteString,
            "https://some/api/v1/"
        )
        
        XCTAssertEqual(
            URL.build(baseURL, path: "../")?.absoluteString,
            "https://some/api/"
        )
        
        XCTAssertEqual(
            URL.build(baseURL, path: "/root")?.absoluteString,
            "https://some/root"
        )
        
        XCTAssertEqual(
            URL.build(baseURL, path: ["users", 1])?.absoluteString,
            "https://some/api/v1/users/1"
        )
        
        XCTAssertEqual(
            URL.build(baseURL, path: ["users", 1, "yury korolev"])?.absoluteString,
            "https://some/api/v1/users/1/yury%20korolev"
        )
        
        XCTAssertEqual(
            URL.build(baseURL, path: ["", "users", 1, "profile", "yury korolev"])?.absoluteString,
            "https://some/users/1/profile/yury%20korolev"
        )
    }
    
    func testQuery() {
        XCTAssertEqual(
            URL.build(baseURL, query: nil)?.absoluteString,
            "https://some/api/v1/"
        )
        
        XCTAssertEqual(
            URL.build(baseURL, query: "nice")?.absoluteString,
            "https://some/api/v1/?nice"
        )
        
        XCTAssertEqual(
            URL.build(baseURL, query: "nice=yes")?.absoluteString,
            "https://some/api/v1/?nice=yes"
        )
        
        XCTAssertEqual(
            URL.build(baseURL, query: [:])?.absoluteString,
            "https://some/api/v1/?"
        )
        
        XCTAssertEqual(
            URL.build(baseURL, query: ["nice": "yes"])?.absoluteString,
            "https://some/api/v1/?nice=yes"
        )
        
        let params = ["object": ["nice": "yes"]]
        XCTAssertEqual(
            URL.build(baseURL, query: params)?.absoluteString,
            "https://some/api/v1/?object%5Bnice%5D=yes"
        )
    }
    
    func testFull() {
        let params = ["object": ["nice": "yes"]]
        
        XCTAssertEqual(
            URL.build(baseURL, path: "../users", query: params, fragment: "hey")?.absoluteString,
            "https://some/api/users?object%5Bnice%5D=yes#hey"
        )
        
        XCTAssertEqual(
            URL.build(baseURL, path: ["users"], query: params, fragment: "hey")?.absoluteString,
            "https://some/api/v1/users?object%5Bnice%5D=yes#hey"
        )
    }
}
