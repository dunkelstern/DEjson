//
//  DEjsonTests.swift
//  DEjsonTests
//
//  Created by Johannes Schriewer on 10.09.15.
//  Copyright © 2015 anfema. All rights reserved.
//

import XCTest
@testable import DEjson

class DEjsonTests: XCTestCase {

    func testJSONDecoderStringFragment() throws {
        let obj = JSONDecoder("\"string\"").jsonObject
        if case .JSONString(let string) = obj {
            XCTAssert(string == "string")
        } else {
            XCTFail("value is not a string")
        }
    }

    func testJSONDecoderNumberFragment() throws {
        let obj = JSONDecoder("1.567").jsonObject
        if case .JSONNumber(let number) = obj {
            XCTAssert(number == 1.567)
        } else {
            XCTFail("value is not a number")
        }
    }

    func testJSONDecoderFalseFragment() throws {
        let obj = JSONDecoder("false").jsonObject
        if case .JSONBoolean(let bool) = obj {
            XCTAssert(bool == false)
        } else {
            XCTFail("value is not a bool")
        }
    }

    func testJSONDecoderTrueFragment() throws {
        let obj = JSONDecoder("true").jsonObject
        if case .JSONBoolean(let bool) = obj {
            XCTAssert(bool == true)
        } else {
            XCTFail("value is not a bool")
        }
    }

    func testJSONDecoderNullFragment() throws {
        let obj = JSONDecoder("null").jsonObject
        if case .JSONNull = obj {
        } else {
            XCTFail("value is not null")
        }
    }

    func testJSONNumberInArray() throws {
        let obj = JSONDecoder("[123, 234]").jsonObject
        if case .JSONArray(let array) = obj {
            XCTAssert(array.count == 2)
            if case .JSONNumber(let num) = array[0] {
                XCTAssert(num == 123)
            } else {
                XCTFail("Not a number")
            }
            if case .JSONNumber(let num) = array[1] {
                XCTAssert(num == 234)
            } else {
                XCTFail("Not a number")
            }
        } else {
            XCTFail("Object not an array")
        }
    }

    func testJSONNumberInDict() throws {
        let obj = JSONDecoder("{\"first\":123, \"second\":234}").jsonObject
        if case .JSONDictionary(let dict) = obj {
            XCTAssert(dict.count == 2)
            if case .JSONNumber(let num) = dict["first"]! {
                XCTAssert(num == 123)
            } else {
                XCTFail("Not a number")
            }
            if case .JSONNumber(let num) = dict["second"]! {
                XCTAssert(num == 234)
            } else {
                XCTFail("Not a number")
            }
        } else {
            XCTFail("Object not a dictionary")
        }
    }

    func testJSONNumberInArrayOfDicts() throws {
        let obj = JSONDecoder("[{\"first\":123,\"second\":234},{\"first\":123,\"second\":234}]").jsonObject
        if case .JSONArray(let array) = obj {
            XCTAssert(array.count == 2)
            for item in array {
                if case .JSONDictionary(let dict) = item {
                    XCTAssert(dict.count == 2)
                    if case .JSONNumber(let num) = dict["first"]! {
                        XCTAssert(num == 123)
                    } else {
                        XCTFail("Not a number")
                    }
                    if case .JSONNumber(let num) = dict["second"]! {
                        XCTAssert(num == 234)
                    } else {
                        XCTFail("Not a number")
                    }
                } else {
                    XCTFail("Object not a dictionary")
                }
            }
        } else {
            XCTFail("Object not array")
        }
    }

    func testJSONDecoderComplex1() throws {
        let obj = JSONDecoder("[{\"t\":\"1\",\"v\":\"1\",\"b\":false},{\"t\":\"2\",\"v\":\"1\",\"b\":false},{\"t\":\"3\",\"v\":\"1\",\"b\":false}]").jsonObject
        if case .JSONArray(let array) = obj {
            XCTAssert(array.count == 3)
            for item in array {
                if case .JSONDictionary(let dict) = item {
                    XCTAssert(dict.keys.count == 3)
                    XCTAssertNotNil(dict["t"])
                    XCTAssertNotNil(dict["v"])
                    XCTAssertNotNil(dict["b"])
                    if case .JSONString(let str) = dict["v"]! {
                        XCTAssert(str == "1")
                    } else {
                        XCTFail("v value is not a string")
                    }
                } else {
                    XCTFail("object not a dictionary")
                }
            }
        } else {
            XCTFail("object returned is not an array")
        }
    }
}

#if os(Linux)
extension DEjsonTests {
    static var allTests : [(String, DEjsonTests -> () throws -> Void)] {
        return [
            ("testJSONDecoderStringFragment", testJSONDecoderStringFragment),
            ("testJSONDecoderNumberFragment", testJSONDecoderNumberFragment),
            ("testJSONDecoderFalseFragment", testJSONDecoderFalseFragment),
            ("testJSONDecoderTrueFragment", testJSONDecoderTrueFragment),
            ("testJSONDecoderNullFragment", testJSONDecoderNullFragment),
            ("testJSONNumberInArray", testJSONNumberInArray),
            ("testJSONNumberInDict", testJSONNumberInDict),
            ("testJSONNumberInArrayOfDicts", testJSONNumberInArrayOfDicts),
            ("testJSONDecoderComplex1", testJSONDecoderComplex1)
        ]
    }
}
#endif