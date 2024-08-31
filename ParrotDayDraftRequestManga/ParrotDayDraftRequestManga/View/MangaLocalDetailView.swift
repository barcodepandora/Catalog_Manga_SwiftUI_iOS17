//
//  MangaLocalDetailView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 30/08/24.
//

import SwiftUI

struct MangaLocalDetailView: View {
    
    private var manga: MangaLocal
    
    init(manga: MangaLocal) {
        self.manga = manga
    }
    
    var body: some View {
        GeometryReader { geometry in 
            VStack {
                AsyncPicture(urlImage: manga.image, pictureWidth: geometry.size.width, pictureHeight: geometry.size.height / 2)
                Text("""
De \(manga.title) tengo \(manga.userManga.volumesOwned.count) volumenes yendo en el \(manga.userManga.readingVolume!)
""")
            }
        }
    }
}

//#Preview {
//    MangaLocalDetailView()
//}
