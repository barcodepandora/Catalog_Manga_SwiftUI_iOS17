//
//  MangaView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 1/07/24.
//

import SwiftUI

struct MangaView: View {
    let mangaItem: Item
    
    var body: some View {
        Text("Hello, Manga!")
        VStack {
            AsyncImage(url: URL(string: mangaItem.mainPicture!.replacingOccurrences(of: "\"", with: ""))) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 125)
            } placeholder: {
                ProgressView()
                    .controlSize(.extraLarge)
            } // Cuando acaba de cargar es como un Image
            .background {
                Color(white: 0.8)
            }
        }
    }
}

#Preview {
    MangaView(mangaItem: Item())
}
