//
//  JSONObject.swift
//  DeJSON
//
//  Created by Johannes Schriewer on 04.02.15.
//  Copyright (c) 2015 anfema. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted under the conditions of the 3-clause
// BSD license (see LICENSE.txt for full license text)

import Foundation

public enum JSONObject {
    case JSONArray([JSONObject])
    case JSONDictionary([String:JSONObject])
    case JSONString(String)
    case JSONNumber(Double)
    case JSONBoolean(Bool)
    case JSONNull
    case JSONInvalid
    
    public enum Error: ErrorType {
        case NotConvertible
    }

    // MARK: - Initializer from basic types
    
    public init(_ string: String?) {
        if let string = string {
            self = .JSONString(string)
        } else {
            self = .JSONNull
        }
    }

    public init<T: UnsignedIntegerType>(_ number: T) {
        switch number {
        case is UInt:
            self = .JSONNumber(Double(number as! UInt))
        case is UInt8:
            self = .JSONNumber(Double(number as! UInt8))
        case is UInt16:
            self = .JSONNumber(Double(number as! UInt16))
        case is UInt32:
            self = .JSONNumber(Double(number as! UInt32))
        case is UInt64:
            self = .JSONNumber(Double(number as! UInt64))
        default:
            self = .JSONInvalid
        }
    }

    public init<T: SignedIntegerType>(_ number: T) {
        switch number {
        case is Int:
            self = .JSONNumber(Double(number as! Int))
        case is Int8:
            self = .JSONNumber(Double(number as! Int8))
        case is Int16:
            self = .JSONNumber(Double(number as! Int16))
        case is Int32:
            self = .JSONNumber(Double(number as! Int32))
        case is Int64:
            self = .JSONNumber(Double(number as! Int64))
        default:
            self = .JSONInvalid
        }
    }

    public init<T: FloatingPointType>(_ number: T) {
        switch number {
        case is Float:
            self = .JSONNumber(Double(number as! Float))
        case is Double:
            self = .JSONNumber(number as! Double)
        default:
            self = .JSONInvalid
        }
    }

    public init(_ bool: Bool) {
        self = .JSONBoolean(bool)
    }
    
    public init(_ array: [JSONObject]) {
        self = .JSONArray(array)
    }
    
    public init(_ dict: [String:JSONObject]) {
        self = .JSONDictionary(dict)
    }
    
    // MARK: - Mapping from JSONObject to type
    
    public func map() throws -> [JSONObject] {
        if case .JSONArray(let array) = self {
            return array
        }
        throw JSONObject.Error.NotConvertible
    }

    public func map() throws -> [String:JSONObject] {
        if case .JSONDictionary(let dict) = self {
            return dict
        }
        throw JSONObject.Error.NotConvertible
    }

    public func map() throws -> String {
        switch self {
        case .JSONString(let string):
            return string
        case .JSONNumber(let number):
            return "\(number)"
        case .JSONBoolean(let value):
            return (value) ? "true" : "false"
        default:
            throw JSONObject.Error.NotConvertible
        }
    }

    public func map<T: FloatingPointType>() throws -> T {
        switch self {
        case .JSONString(let string):
            if let n:T = self.StringToFloat(string) {
                return n
            } else {
                throw JSONObject.Error.NotConvertible
            }
        case .JSONNumber(let number):
            switch T(0) {
            case is Double:
                return number as! T
            case is Float:
                return Float(number) as! T
            default:
                throw JSONObject.Error.NotConvertible
            }
        case .JSONBoolean(let value):
            return T(((value) ? 1 : 0))
        default:
            throw JSONObject.Error.NotConvertible
        }
    }

    public func map<T: UnsignedIntegerType>() throws -> T {
        switch self {
        case .JSONString(let string):
            if let n:T = self.StringToUInt(string) {
                return n
            } else {
                throw JSONObject.Error.NotConvertible
            }
        case .JSONNumber(let number):
            if let n:T = self.DoubleToUInt(number) {
                return n
            } else {
                throw JSONObject.Error.NotConvertible
            }
        case .JSONBoolean(let value):
            return T(((value) ? 1 : 0))
        default:
            throw JSONObject.Error.NotConvertible
        }
    }

    public func map<T: SignedIntegerType>() throws -> T {
        switch self {
        case .JSONString(let string):
            if let n:T = self.StringToInt(string) {
                return n
            } else {
                throw JSONObject.Error.NotConvertible
            }
        case .JSONNumber(let number):
            if let n:T = self.DoubleToInt(number) {
                return n
            } else {
                throw JSONObject.Error.NotConvertible
            }
        case .JSONBoolean(let value):
            return T(((value) ? 1 : 0))
        default:
            throw JSONObject.Error.NotConvertible
        }
    }

    public func map() throws -> Bool {
        switch self {
        case .JSONString(let string):
            let lc = string.lowercaseString
            if lc == "true" || lc == "yes" || lc == "1" || lc == "on" {
                return true
            }
            if lc == "false" || lc == "no" || lc == "0" || lc == "off" {
                return false
            }
            throw JSONObject.Error.NotConvertible
        case .JSONNull:
            return false
        case .JSONNumber(let number):
            if Int(number) != 0 {
                return true
            } else {
                return false
            }
        case .JSONBoolean(let value):
            return value
        default:
            throw JSONObject.Error.NotConvertible
        }
        
    }
    
    // MARK: - Workarounds for Swift 2.0 not naming protocols correctly
    
    private func DoubleToUInt<T: UnsignedIntegerType>(number: Double) -> T? {
        switch T(0) {
        case is UInt:
            return UInt(number) as? T
        case is UInt8:
            return UInt8(number) as? T
        case is UInt16:
            return UInt16(number) as? T
        case is UInt32:
            return UInt32(number) as? T
        case is UInt64:
            return UInt64(number) as? T
        default:
            return nil
        }
    }
    
    private func StringToUInt<T: UnsignedIntegerType>(string: String) -> T? {
        switch T(0) {
        case is UInt:
            return UInt(string) as? T
        case is UInt8:
            return UInt8(string) as? T
        case is UInt16:
            return UInt16(string) as? T
        case is UInt32:
            return UInt32(string) as? T
        case is UInt64:
            return UInt64(string) as? T
        default:
            return nil
        }
    }

    private func DoubleToInt<T: SignedIntegerType>(number: Double) -> T? {
        switch T(0) {
        case is Int:
            return Int(number) as? T
        case is Int8:
            return Int8(number) as? T
        case is Int16:
            return Int16(number) as? T
        case is Int32:
            return Int32(number) as? T
        case is Int64:
            return Int64(number) as? T
        default:
            return nil
        }
    }

    private func StringToInt<T: SignedIntegerType>(string: String) -> T? {
        switch T(0) {
        case is Int:
            return Int(string) as? T
        case is Int8:
            return Int8(string) as? T
        case is Int16:
            return Int16(string) as? T
        case is Int32:
            return Int32(string) as? T
        case is Int64:
            return Int64(string) as? T
        default:
            return nil
        }
    }

    private func StringToFloat<T: FloatingPointType>(string: String) -> T? {
        switch T(0) {
        case is Double:
            return Double(string) as? T
        case is Float:
            return Float(string) as? T
        default:
            return nil
        }
    }
    
}
