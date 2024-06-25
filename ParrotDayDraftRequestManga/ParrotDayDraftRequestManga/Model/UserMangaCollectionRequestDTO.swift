//
//  UserMangaCollectionRequestDTO.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 25/06/24.
//

import Foundation

struct UserMangaCollectionRequestDTO {
    var manga: Int
    var completeCollection: Bool
    var volumesOwned: [Int]
    var readingVolume: Int?

    init(manga: Int? = 0, completeCollection: Bool? = false, volumesOwned: [Int]? = [], readingVolume: Int? = 0) {
        self.manga = manga!
        self.completeCollection = completeCollection!
        self.volumesOwned = volumesOwned!
        self.readingVolume = readingVolume!
    }
}

extension UserMangaCollectionRequestDTO: Decodable {
}
