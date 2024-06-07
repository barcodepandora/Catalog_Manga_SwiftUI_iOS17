//
//  Manga.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 5/06/24.
//

import Foundation

struct Manga {
    var info: MangaInfo?
    var items: [Item]?
    
    init(info: MangaInfo? = nil, items: [Item]? = []) {
        self.info = info
        self.items = items
    }
}

extension Manga: Decodable {}

struct MangaInfo {
    var name: String?
    var items: [Item]?
    
    init(name: String? = nil, items: [Item]? = []) {
        self.name = name
        self.items = items
    }
}

extension MangaInfo: Decodable {}

struct Item {
    var title: String?
    
    init(title: String? = nil) {
        self.title = title
    }
}

extension Item: Decodable {}

