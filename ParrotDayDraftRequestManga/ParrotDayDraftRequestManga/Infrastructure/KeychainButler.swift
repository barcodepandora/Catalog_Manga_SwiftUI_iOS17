//
//  KeychainButler.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 1/07/24.
//

import Foundation
import Security

class KeychainButler {
    static func storeData(data: Data, forService service: String, account: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service, kSecAttrAccount as String: account, kSecValueData as String: data
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    static func retrieveData(forService service: String, account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service, kSecAttrAccount as String: account, kSecReturnData as String: true, kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess {
            if let data = result as? Data {
                return data
            }
        } else {
            print("KO: \(status)")
        }
        return nil
    }
}
