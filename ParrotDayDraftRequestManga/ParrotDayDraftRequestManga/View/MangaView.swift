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
//            AsyncImage(url: URL(string: mangaItem.mainPicture!)) { image in
//                image
//                    .resizable()
//                    .scaledToFill()
//            }
            
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
//            .clipShape(Circle())
//            .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
        }
    }
}

struct PokemonAvatarView: View {
    let url: URL

    var body: some View {
        AsyncImage(url: URL(string: "")) { image in
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
        .clipShape(Circle())
        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    MangaView(mangaItem: Item())
}
