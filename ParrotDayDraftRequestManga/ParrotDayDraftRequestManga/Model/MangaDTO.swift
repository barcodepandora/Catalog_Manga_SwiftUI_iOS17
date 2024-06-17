//
//  MangaDTO.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 5/06/24.
//

import Foundation

struct MangaDTO {
    var metadata: MangaInfoDTO?
    var items: [ItemDTO]?
    
    init(metadata: MangaInfoDTO? = nil, items: [ItemDTO]? = []) {
        self.metadata = metadata
        self.items = items
    }
}

extension MangaDTO: Decodable {
    var manga: Manga {
        Manga(metadata: self.metadata?.mangaInfo, items: self.items?.compactMap { Item(title: $0.title!) } ?? [])
    }
}

struct MangaInfoDTO {
    var name: String?
    
    init(name: String? = nil) {
        self.name = name
    }
}

extension MangaInfoDTO: Decodable {
    var mangaInfo: MangaInfo {
        MangaInfo(total: 1)
    }
}

struct ItemDTO {
    var title: String?
    
    init(title: String? = nil) {
        self.title = title
    }
}

extension ItemDTO: Decodable {
    var item: Item {
        Item(title: self.title)
    }
}

