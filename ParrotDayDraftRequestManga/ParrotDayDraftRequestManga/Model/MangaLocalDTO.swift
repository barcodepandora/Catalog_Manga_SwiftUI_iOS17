//
//  MangaLocalDTO.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 14/07/24.
//

import Foundation

struct MangaLocalDTO {
    var title: String
    var userManga: UserMangaCollectionRequestDTO
    var image: String
    
    init(title: String? = "", userManga: UserMangaCollectionRequestDTO? = UserMangaCollectionRequestDTO(), image: String? = "") {
        self.title = title!
        self.userManga = userManga!
        self.image = image!
    }
}

extension MangaLocalDTO: Decodable {
    var mangaLocal: MangaLocal {
        MangaLocal(title: self.title, userManga: self.userManga.userManga, image: self.image)
    }
}
