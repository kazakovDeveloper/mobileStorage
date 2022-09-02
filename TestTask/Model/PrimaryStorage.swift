//
//  Model.swift
//  TestTask
//
//  Created by Kazakov Danil on 02.09.2022.
//

import Foundation


class PrimaryStorage: MobileStorage {
    
    private var phones: Set<Mobile> {
        get {
            if let data = UserDefaults.standard.data(forKey: "phonesKEY") {
                let decodedSet = (try? JSONDecoder().decode(Set<Mobile>.self, from: data)) ?? Set<Mobile>()
                return decodedSet
            }
            return Set<Mobile>()
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: "phonesKEY")
            UserDefaults.standard.synchronize()
        }
    }
    
    enum ErrorStorage: Error {
        case ErrorIMEIExists
        case ErrorMobileNotExists
    }
    
    func getAll() -> Set<Mobile> {
        phones
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        phones.first { $0.imei == imei }
    }
    
    func save(mobile: Mobile) throws -> Mobile {
        if findByImei(mobile.imei) != nil {
            //return error
            throw ErrorStorage.ErrorIMEIExists
        }
        
        phones.insert(mobile)
        return mobile
    }
    
    func delete(_ product: Mobile) throws {
        if !exist(product) {
            throw ErrorStorage.ErrorMobileNotExists
        }
        phones.remove(product)
    }
    
    func exist(_ product: Mobile) -> Bool {
        phones.contains(product)
    }
}
