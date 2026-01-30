//
//  LogExporter.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/30.
//

import Foundation

enum LogExporter {

    static func export() throws -> URL {
        let fileLogger = FileLogger()

        let dir = FileManager.default.temporaryDirectory
        let url = dir.appendingPathComponent("bug-report.log")

        if let data = fileLogger.readAll() {
            try data.write(to: url)
        }

        return url
    }
}
