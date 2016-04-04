//
//  EncodingTests.swift
//  SafeURL
//
//  Created by Yury Korolev on 4/4/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import SafeURL

class QueryEncodingTests: XCTestCase {
    
    let baseURL = NSURL(string: "https://example.com/")!
    
    func testNoArgs() {
        let url = baseURL.build()
        XCTAssertNil(url!.query)
    }
    
    func testNil() {
        let url = baseURL.build(query: nil)
        XCTAssertNil(url!.query)
    }
    
    func testEmpty() {
        let url = baseURL.build(query: [:])
        // NOTE: we are different here with alamofire
        XCTAssertEqual(url!.query, "")
    }
    
    func testString() {
        let url = baseURL.build(query: "foo=true&boo=nice test")
        // NOTE: we are different here with alamofire
        XCTAssertEqual(url!.query, "foo=true&boo=nice%20test")
    }
    
    func testOneStringKeyStringValue() {
        let url = baseURL.build(query: ["foo": "bar"])
        XCTAssertEqual(url!.query, "foo=bar")
    }
    
    func testEncodeTwoStringKeyStringValue() {
        let url = baseURL.build(query: ["foo": "bar", "baz": "qux"])
        XCTAssertEqual(url!.query, "baz=qux&foo=bar")
    }
    
    func testStringKeyIntegerValue() {
        let url = baseURL.build(query: ["foo": 1])
        XCTAssertEqual(url!.query, "foo=1")
    }
    
    func testStringKeyDoubleValue() {
        let url = baseURL.build(query: ["foo": 1.1])
        XCTAssertEqual(url!.query, "foo=1.1")
    }
    
    func testStringKeyBoolValue() {
        let url = baseURL.build(query: ["foo": true])
        XCTAssertEqual(url!.query, "foo=1")
    }
    
    func testStringKeyNullValue() {
        let url = baseURL.build(query: ["foo": NSNull()])
        XCTAssertEqual(url!.query, "foo")
    }
    
    func testStringKeyTwoNullValue() {
        let url = baseURL.build(query: ["foo": NSNull(), "boo": NSNull()])
        XCTAssertEqual(url!.query, "boo&foo")
    }
    
    func testStringKeyArrayValue() {
        let url = baseURL.build(query: ["foo": ["a", 1, true]])
        XCTAssertEqual(url!.query, "foo%5B%5D=a&foo%5B%5D=1&foo%5B%5D=1")
    }
    
    func testStringKeyDictionaryValue() {
        let url = baseURL.build(query: ["foo": ["bar": 1]])
        XCTAssertEqual(url!.query, "foo%5Bbar%5D=1")
    }
    
    func testStringKeyNestedDictionaryValue() {
        let url = baseURL.build(query: ["foo": ["bar": ["baz": 1]]])
        XCTAssertEqual(url!.query, "foo%5Bbar%5D%5Bbaz%5D=1")
    }
    
    func testStringKeyNestedDictionaryArrayValue() {
        let url = baseURL.build(query: ["foo": ["bar": ["baz": ["a", 1, true]]]])
        XCTAssertEqual(url!.query, "foo%5Bbar%5D%5Bbaz%5D%5B%5D=a&foo%5Bbar%5D%5Bbaz%5D%5B%5D=1&foo%5Bbar%5D%5Bbaz%5D%5B%5D=1")
    }
    
    func testStringWithAmpersandKeyStringWithAmpersandValue() {
        let url = baseURL.build(query: ["foo&bar": "baz&qux", "foobar": "bazqux"])
        XCTAssertEqual(url!.query, "foo%26bar=baz%26qux&foobar=bazqux")
    }
    
    func testStringWithQuestionMarkKeyStringWithQuestionMarkValue() {
        let url = baseURL.build(query: ["?foo?": "?bar?"])
        XCTAssertEqual(url!.query, "?foo?=?bar?")
    }
    
    func testStringWithSlashKeyStringWithQuestionMarkValue() {
        let url = baseURL.build(query: ["foo": "/bar/baz/qux"])
        XCTAssertEqual(url!.query, "foo=/bar/baz/qux")
    }
    
    func testStringWithSpaceKeyStringWithSpaceValue() {
        let url = baseURL.build(query: [" foo ": " bar "])
        XCTAssertEqual(url!.query, "%20foo%20=%20bar%20")
    }
    
    func testStringWithPlusKeyStringWithPlusValue() {
        let url = baseURL.build(query: ["+foo+": "+bar+"])
        XCTAssertEqual(url!.query, "+foo+=+bar+")
    }
    
    func testStringKeyPercentEncodedStringValueParameter() {
        let url = baseURL.build(query: ["percent": "%25"])
        XCTAssertEqual(url!.query, "percent=%2525")
    }
    
    func testStringKeyNonLatinStringValueParameter() {
        
        let query =  [
            "french": "français",
            "japanese": "日本語",
            "arabic": "العربية",
            "emoji": "😃"
        ]
        
        let url = baseURL.build(query: query)
        
        let expectedQueryValues = [
            "arabic=%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A%D8%A9",
            "emoji=%F0%9F%98%83",
            "french=fran%C3%A7ais",
            "japanese=%E6%97%A5%E6%9C%AC%E8%AA%9E"
        ]
        XCTAssertEqual(url!.query, expectedQueryValues.joinWithSeparator("&"))
    }
    
    func testStringWithThousandsOfChineseCharacters() {
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
        XCTAssertEqual(url.query, expected)
    }
    
}