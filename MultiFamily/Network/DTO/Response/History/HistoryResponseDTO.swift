//
//  HistoryResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

import Foundation

struct HistoryResponseDTO: Decodable {


    let id: String
    let idType: String
    let activity: [HistoryActivityDTO]


}

struct HistoryActivityDTO: Decodable {

    let type: Int
    let detail: HistoryDetailDTO?
    let millisecond: Double

}

struct HistoryDetailDTO: Decodable {

    let from: String?
    let to: String?
    let message: String?

}
extension HistoryResponseDTO {

    func toDomain() -> [History] {

        activity.map {

            History(
                type: HistoryType(value: $0.type),
                from: $0.detail?.from,
                to: $0.detail?.to,
                message: $0.detail?.message,
                date: Date(timeIntervalSince1970: TimeInterval($0.millisecond) / 1000)
            )

        }
    }
}
