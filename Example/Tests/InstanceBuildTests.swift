//
//  InstanceBuildTests.swift
//  SafeURL
//
//  Created by Yury Korolev on 4/2/16.
//  Copyright © 2016 CocoaPods. All rights reserved.

import Foundation
import UIKit
import Foundation
import XCTest
import SafeURL

class InstanceBuildTests: XCTestCase {
    
    let baseURL = NSURL(string: "https://some/api/v1/")!
    
    func testPath() {
        XCTAssertEqual(
            baseURL.build()?.absoluteString,
            "https://some/api/v1/"
        )
        
        XCTAssertEqual(
            baseURL.build("../")?.absoluteString,
            "https://some/api/"
        )
        
        XCTAssertEqual(
            baseURL.build("/root")?.absoluteString,
            "https://some/root"
        )
        
        XCTAssertEqual(
            baseURL.build(["users", 1])?.absoluteString,
            "https://some/api/v1/users/1"
        )
        
        XCTAssertEqual(
            baseURL.build(["users", 1, "yury korolev"])?.absoluteString,
            "https://some/api/v1/users/1/yury%20korolev"
        )
        
        XCTAssertEqual(
            baseURL.build(["", "users", 1, "yury korolev"])?.absoluteString,
            "https://some/users/1/yury%20korolev"
        )
    }
    
    func testQuery() {
        XCTAssertEqual(
            baseURL.build(query: nil)?.absoluteString,
            "https://some/api/v1/"
        )
        
        XCTAssertEqual(
            baseURL.build(query: "nice")?.absoluteString,
            "https://some/api/v1/?nice"
        )
        
        XCTAssertEqual(
            baseURL.build(query: "nice=yes")?.absoluteString,
            "https://some/api/v1/?nice=yes"
        )
        
        XCTAssertEqual(
            baseURL.build(query: [:])?.absoluteString,
            "https://some/api/v1/?"
        )
        
        XCTAssertEqual(
            baseURL.build(query: ["nice": "yes"])?.absoluteString,
            "https://some/api/v1/?nice=yes"
        )
        
        let params = ["object": ["nice": "yes"]]
        XCTAssertEqual(
            baseURL.build(query: params)?.absoluteString,
            "https://some/api/v1/?object%5Bnice%5D=yes"
        )
    }
    
    func testFull() {
        let params = ["object": ["nice": "yes"]]
        
        XCTAssertEqual(
            baseURL.build("../users", query: params, fragment: "hey")?.absoluteString,
            "https://some/api/users?object%5Bnice%5D=yes#hey"
        )
        
        XCTAssertEqual(
            baseURL.build(["users"], query: params, fragment: "hey")?.absoluteString,
            "https://some/api/v1/users?object%5Bnice%5D=yes#hey"
        )
    }
}