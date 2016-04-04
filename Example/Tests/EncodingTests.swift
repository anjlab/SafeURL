//
//  EncodingTests.swift
//  SafeURL
//
//  Created by Yury Korolev on 4/4/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import Foundation
import XCTest
import SafeURL

class EncodingTests: XCTestCase {
   
    
    func testQueryEncodeStringWithThousandsOfChineseCharacters() {
        // Given
        let repeatedCount = 2_000
        let baseURL = NSURL(string: "https://example.com/movies")!
        var input: String = ""
        for _ in 0..<repeatedCount {
            input += "一二三四五六七八九十"
        }
        let query = ["chinese": input]
        
        let url = baseURL.build(query: query)!
        
        var expected = "chinese="
        for _ in 0..<repeatedCount {
            expected += "%E4%B8%80%E4%BA%8C%E4%B8%89%E5%9B%9B%E4%BA%94%E5%85%AD%E4%B8%83%E5%85%AB%E4%B9%9D%E5%8D%81"
        }
        XCTAssertEqual(url.query, expected, "query is incorrect")
    }
    
}