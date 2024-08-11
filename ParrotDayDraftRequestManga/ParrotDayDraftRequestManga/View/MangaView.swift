//
//  MangaView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 1/07/24.
//

import SwiftUI

struct MangaView: View {
    let mangaItem: Item
    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    
    var body: some View {
        HStack {
            VStack {
                Text(mangaItem.background!)
                    .font(.footnote)
                    .lineSpacing(5) // adjust this value to change the line spacing
                    .multilineTextAlignment(.leading) // adjust this value to change the text alignment
                    .padding(.horizontal, 20) // adjust this value to change the horizontal padding
                    .padding(.vertical, 10) // adjust this value to change the vertical padding

            }
            VStack {
                VStack {
                    AsyncImage(url: URL(string: mangaItem.mainPicture!.replacingOccurrences(of: "\"", with: ""))) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 159, height: 198)
                            .scaleEffect(scale)
                            .offset(offset)
                            .gesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        self.scale = value
                                    }
                                    .onEnded { _ in
                                        withAnimation {
                                            self.scale = 1.0
                                            self.offset = .zero
                                        }
                                    }
                            )
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        self.offset = value.translation
                                    }
                                    .onEnded { _ in
                                        withAnimation {
                                            self.offset = .zero
                                        }
                                    }
                            )
                    } placeholder: {
                        ProgressView()
                            .controlSize(.extraLarge)
                    } // Cuando acaba de cargar es como un Image
                    .background {
                        Color(white: 0.8)
                    }
                    FavoriteView(item: mangaItem)
                }
                Text(mangaItem.title!)
                    .font(.title)

                Text(mangaItem.sypnosis!)
                    .font(.footnote)
                    .lineSpacing(5) // adjust this value to change the line spacing
                    .multilineTextAlignment(.leading) // adjust this value to change the text alignment
                    .padding(.horizontal, 20) // adjust this value to change the horizontal padding
                    .padding(.vertical, 10) // adjust this value to change the vertical padding

            }
        }

    }
}

#Preview {
    MangaView(mangaItem: Item())
}
