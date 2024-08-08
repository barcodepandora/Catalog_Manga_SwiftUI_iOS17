//
//  Manga.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 5/06/24.
//

import Foundation
import SwiftData

@Model
class Manga: Codable {
    @Attribute(.unique)
    var name: String?
    let metadata: MangaInfo
    let items: [Item]
    let yo = "Juan"

    init(name: String? = "", metadata: MangaInfo? = MangaInfo(), items: [Item]? = []) {
        self.metadata = metadata!
        self.items = items!
    }

    enum CodingKeys: CodingKey {
        case metadata, items
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        metadata = try values.decodeIfPresent(MangaInfo.self, forKey: .metadata)!
        items = try values.decodeIfPresent([Item].self, forKey: .items)!
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(metadata, forKey: .metadata)
      try container.encode(items, forKey: .items)
    }
}

@Model
class MangaInfo: Codable {
    let total: Int

    init(total: Int? = 0) {
        self.total = total!
    }

    enum CodingKeys: String, CodingKey{
        case total
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total = try values.decodeIfPresent(Int.self, forKey: .total)!
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(total, forKey: .total)
    }
}

@Model
class Item: Codable {
    let title: String?
    let mainPicture: String?
    let background: String?
    let sypnosis: String?
    var isFavorite: Bool = false

    init(title: String? = nil, mainPicture: String? = "", background: String? = "", sypnosis: String? = "") {
        self.title = title
        self.mainPicture = mainPicture
        self.background = background
        self.sypnosis = sypnosis
    }

    enum CodingKeys: String, CodingKey{
        case title
        case mainPicture
        case background
        case sypnosis
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        mainPicture = try values.decodeIfPresent(String.self, forKey: .mainPicture)
        background = try values.decodeIfPresent(String.self, forKey: .background)
        sypnosis = try values.decodeIfPresent(String.self, forKey: .sypnosis)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(mainPicture, forKey: .mainPicture)
        try container.encode(background, forKey: .background)
        try container.encode(sypnosis, forKey: .sypnosis)
    }
}

