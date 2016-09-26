import Foundation
import XCTest
import SafeURL

class GeneralBuildTests: XCTestCase {
    
    func testBuild() {
        XCTAssertEqual(
            URL.build(scheme: "mailto", path: "valid.email+group@gmail.com")?.absoluteString,
            "mailto:valid.email+group@gmail.com"
        )
        
        XCTAssertEqual(
            URL.build(scheme: "mailto", path: "do not know@gmail.com")?.absoluteString,
            "mailto:do%20not%20know@gmail.com"
        )

        XCTAssertEqual(
            URL.build(scheme: "tel", path: "+7 (910) 670 14 00")?.absoluteString,
            "tel:+7%20(910)%20670%2014%2000"
        )
        
        XCTAssertEqual(
            URL.build(scheme: "https", host: "google.com", port: 8080, path: "/search", query: ["q": "hello world."], fragment: "open")?.absoluteString,
            "https://google.com:8080/search?q=hello%20world.#open"
        )
    }
}
