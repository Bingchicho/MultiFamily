//
//  AnyEncodable.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/30.
//

import Foundation

struct AnyEncodable: Encodable {

    private let _encode: (Encoder) throws -> Void

    init<T: Encodable>(_ value: T) {
        self._encode = value.encode
    }

    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
