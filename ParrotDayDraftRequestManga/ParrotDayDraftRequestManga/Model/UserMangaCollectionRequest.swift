//
//  UserMangaCollectionRequest.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 14/07/24.
//

import Foundation
import SwiftData

@Model
class UserMangaCollectionRequest: Codable {
    let manga: Int
    let completeCollection: Bool
    let volumesOwned: [Int]
    let readingVolume: Int?

    init(manga: Int? = 0, completeCollection: Bool? = false, volumesOwned: [Int]? = [], readingVolume: Int? = 0) {
        self.manga = manga!
        self.completeCollection = completeCollection!
        self.volumesOwned = volumesOwned!
        self.readingVolume = readingVolume!
        
    }
    
    enum CodingKeys: String, CodingKey{
        case manga
        case completeCollection
        case volumesOwned
        case readingVolume
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        manga = try values.decodeIfPresent(Int.self, forKey: .manga)!
        completeCollection = try values.decodeIfPresent(Bool.self, forKey: .completeCollection)!
        volumesOwned = try values.decodeIfPresent([Int].self, forKey: .volumesOwned)!
        readingVolume = try values.decodeIfPresent(Int.self, forKey: .readingVolume)!
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(manga, forKey: .manga)
        try container.encode(completeCollection, forKey: .completeCollection)
        try container.encode(volumesOwned, forKey: .volumesOwned)
        try container.encode(readingVolume, forKey: .readingVolume)
    }
}
