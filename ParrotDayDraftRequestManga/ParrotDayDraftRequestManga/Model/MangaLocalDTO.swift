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
    
    init(title: String? = "", userManga: UserMangaCollectionRequestDTO? = UserMangaCollectionRequestDTO()) {
        self.title = title!
        self.userManga = userManga!
    }
}

extension MangaLocalDTO: Decodable {
    var mangaLocal: MangaLocal {
        MangaLocal(title: self.title, userManga: self.userManga.userManga)
    }
}
