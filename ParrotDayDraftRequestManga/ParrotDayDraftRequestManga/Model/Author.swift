//
//  Author.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 30/07/24.
//

import Foundation

struct Author {
    var firstName: String?
    var id: String?
    var lastName: String?
    var role: String?
    
    init(firstName: String? = nil, id: String? = nil, lastName: String? = nil, role: String? = nil) {
        self.firstName = firstName
        self.id = id
        self.lastName = lastName
        self.role = role
    }
}

extension Author: Decodable {
}
