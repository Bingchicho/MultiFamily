//
//  FileLogger.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/30.
//

import Foundation

final class FileLogger {

    private let fileURL: URL
    private let queue = DispatchQueue(label: "file.logger.queue")

    init() {
        let dir = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first!

        fileURL = dir.appendingPathComponent("app.log")

        if !FileManager.default.fileExists(atPath: fileURL.path) {
            FileManager.default.createFile(
                atPath: fileURL.path,
                contents: nil
            )
        }
    }

    func write(_ message: String) {
        queue.async {
            guard let data = (message + "\n").data(using: .utf8) else { return }
            if let handle = try? FileHandle(forWritingTo: self.fileURL) {
                handle.seekToEndOfFile()
                handle.write(data)
                try? handle.close()
            }
        }
    }

    func readAll() -> Data? {
        try? Data(contentsOf: fileURL)
    }

    func clear() {
        try? FileManager.default.removeItem(at: fileURL)
    }
}
