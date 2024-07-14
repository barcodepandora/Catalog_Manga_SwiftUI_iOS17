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

    init(title: String? = "0", userManga: UserMangaCollectionRequest? = UserMangaCollectionRequest()) {
        self.title = title!
        self.userManga = userManga!
        
    }
    
    enum CodingKeys: String, CodingKey{
        case title
        case userManga
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)!
        userManga = try values.decodeIfPresent(UserMangaCollectionRequest.self, forKey: .userManga)!
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(userManga, forKey: .userManga)
    }
}
