//
//  Page.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 10/06/24.
//

import Foundation

struct Page {
    var id: Int?
    var desc: String?
    
    init(id: Int = 0,desc: String? = nil) {
        self.id = id
        self.desc = desc
    }
}

extension Page: Identifiable {
}
