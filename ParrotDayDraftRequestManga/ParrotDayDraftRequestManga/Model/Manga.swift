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
//        self.name = name
        self.metadata = metadata!
        self.items = items!
    }
//}
//
//extension Manga: Decodable {
    enum CodingKeys: CodingKey {
        case metadata, items
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
//        info = try values.decodeIfPresent(MangaInfo.self, forKey: .info)
        metadata = try values.decodeIfPresent(MangaInfo.self, forKey: .metadata)!
        items = try values.decodeIfPresent([Item].self, forKey: .items)!
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
//      try container.encode(info, forKey: .info)
      try container.encode(metadata, forKey: .metadata)
      try container.encode(items, forKey: .items)

    }

}

@Model
class MangaInfo: Codable {
//    let name: String?
//    let items: [Item]?
    let total: Int

    init(total: Int? = 0) {
        self.total = total!
//        self.items = items
    }
//}
//
//extension MangaInfo: Decodable {
    enum CodingKeys: String, CodingKey{
        case total
//        case items
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total = try values.decodeIfPresent(Int.self, forKey: .total)!
//        items = try values.decodeIfPresent([Item].self, forKey: .items)
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(total, forKey: .total)
//      try container.encode(items, forKey: .items)
    }

}

@Model
class Item: Codable {
    let title: String?

    init(title: String? = nil) {
        self.title = title
    }
//}
//
//extension Item: Decodable {
    enum CodingKeys: String, CodingKey{
        case title
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(title, forKey: .title)
    }
}

