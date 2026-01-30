//
//  Untitled.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/30.
//

import Foundation

extension Encodable {

    func toJSONString(
        encoder: JSONEncoder = JSONEncoder(),
        prettyPrinted: Bool = true
    ) -> String? {

        let encoder = encoder
        if prettyPrinted {
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        }

        guard let data = try? encoder.encode(AnyEncodable(self)) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}
