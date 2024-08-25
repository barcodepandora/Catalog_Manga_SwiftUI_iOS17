//
//  CatalogView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 26/07/24.
//

import SwiftUI

enum Direction {
    case forward
    case back
}
struct CatalogView: View {
    let callback: (Direction) -> Void
    
    @Binding var manga: Manga?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                ForEach(deliverManga()) { item in
                    NavigationLink(destination: MangaView(mangaItem: item)) {
                        VStack {
                            FavoriteView(item: item)
                            ZStack {
                                AsyncImage(url: URL(string: item.mainPicture!.replacingOccurrences(of: "\"", with: ""))) { image in
                                    // Display the loaded image
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 93, height: 109)
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                        )
                                        .shadow(radius: 5)
                                } placeholder: {
                                    Image("MacWatch")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .animation(.easeInOut)

                                } // Cuando acaba de cargar es como un Image
                                .background {
                                    Color(white: 1)
                                }
                                CircularTextView(title: item.title!, radius: 78)
                            }
                            .background {
                                Color(white: 1)
                            }
                        }
                    }
                    .navigationTitle("My Manga")
                    .navigationBarTitleDisplayMode(.inline)
                    .font(.custom("Arial", size: 14))
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    let direction: Direction
                    if value.translation.width > 50 {
                        direction = .back
                    } else {
                        direction = .forward
                    }
                    callback(direction)
                }
        )
    }
    
    func deliverManga() -> [Item] {
        if manga != nil && !manga!.items.isEmpty {
            return manga!.items
        } else {
            return [Item]()
        }
    }
}
