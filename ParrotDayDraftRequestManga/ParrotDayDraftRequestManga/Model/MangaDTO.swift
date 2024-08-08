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
        Manga(metadata: self.metadata?.mangaInfo, items: self.items?.compactMap { Item(title: $0.title!, mainPicture: $0.mainPicture ?? "", background: $0.background ?? "", sypnosis: $0.sypnosis ?? "") } ?? [])
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
    var mainPicture: String?
    var background: String?
    var sypnosis: String?

    init(title: String? = nil, mainPicture: String? = "", background: String? = "", sypnosis: String? = "") {
        self.title = title
        self.mainPicture = mainPicture
        self.background = background
        self.sypnosis = sypnosis
    }
}

extension ItemDTO: Decodable {
    var item: Item {
        Item(title: self.title, mainPicture: self.mainPicture, background: self.background, sypnosis: self.sypnosis)
    }
}

