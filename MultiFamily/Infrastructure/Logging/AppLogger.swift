//
//  AppLogger.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/30.
//

import Foundation
import os

enum AppLogger {

    private static let subsystem = Bundle.main.bundleIdentifier ?? "App"

    @available(iOS 14.0, *)
    private static let loggers: [LogCategory: Logger] = {
        Dictionary(uniqueKeysWithValues:
            LogCategory.allCases.map {
                ($0, Logger(subsystem: subsystem, category: $0.rawValue))
            }
        )
    }()

    private static let fileLogger = FileLogger()

    static func log(
        _ level: LogLevel,
        category: LogCategory,
        _ message: String,
        metadata: [String: String] = [:]
    ) {
        let masked = maskSensitive(message)
        let formatted = format(level, category, masked, metadata)

        // OSLog
        if #available(iOS 14.0, *) {
            let logger = loggers[category]!
            switch level {
            case .debug:
                logger.debug("\(formatted, privacy: .private)")
            case .info:
                logger.info("\(formatted, privacy: .private)")
            case .warning:
                logger.warning("\(formatted, privacy: .private)")
            case .error:
                logger.error("\(formatted, privacy: .private)")
            }
        } else {
            let oslog = OSLog(subsystem: subsystem, category: category.rawValue)
            os_log("%{public}@", log: oslog, type: level.osLogType, formatted)
        }

        // File
        fileLogger.write(formatted)
    }
}

private extension AppLogger {

    static func maskSensitive(_ message: String) -> String {
        message
            .replacingOccurrences(
                of: #"("password"\s*:\s*")[^"]+""#,
                with: #"$1***""#,
                options: .regularExpression
            )
            .replacingOccurrences(
                of: #"Bearer\s+[A-Za-z0-9\-\._]+"#,
                with: "Bearer ***",
                options: .regularExpression
            )
    }

    static func format(
        _ level: LogLevel,
        _ category: LogCategory,
        _ message: String,
        _ metadata: [String: String]
    ) -> String {

        let meta = metadata
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: " ")

        let time = dateFormatter.string(from: Date())
        return "[\(time)][\(level.rawValue)][\(category.rawValue)] \(message) \(meta)"
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }()
}


private extension LogLevel {
    var osLogType: OSLogType {
        switch self {
        case .debug: return .debug
        case .info: return .info
        case .warning: return .default
        case .error: return .error
        }
    }
}
