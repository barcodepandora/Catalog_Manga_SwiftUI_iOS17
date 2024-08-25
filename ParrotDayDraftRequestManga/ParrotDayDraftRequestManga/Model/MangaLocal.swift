//
//  MangaLocal.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 14/07/24.
//

import Foundation
import SwiftData

@Model
class MangaLocal: Codable {
    @Attribute(.unique)
    let title: String
    let userManga: UserMangaCollectionRequest
    let image: String

    init(title: String? = "", userManga: UserMangaCollectionRequest? = UserMangaCollectionRequest(), image: String? = "") {
        self.title = title!
        self.userManga = userManga!
        self.image = image!
    }
    
    enum CodingKeys: String, CodingKey{
        case title
        case userManga
        case image
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)!
        userManga = try values.decodeIfPresent(UserMangaCollectionRequest.self, forKey: .userManga)!
        image = try values.decodeIfPresent(String.self, forKey: .image)!
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(userManga, forKey: .userManga)
        try container.encode(image, forKey: .image)
    }
}
