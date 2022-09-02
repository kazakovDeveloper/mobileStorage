//
//  Protocol.swift
//  TestTask
//
//  Created by Kazakov Danil on 02.09.2022.
//

import Foundation

protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei: String) -> Mobile?
    func save(mobile: Mobile) throws -> Mobile
    func delete(_ product: Mobile) throws
    func exist(_ product: Mobile) -> Bool
}


struct Mobile: Hashable, Codable {
    let imei: String
    let name: String
}
