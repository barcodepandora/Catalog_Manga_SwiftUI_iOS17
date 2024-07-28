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
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                ForEach(deliverManga()) { item in
                    NavigationLink(destination: MangaView(mangaItem: item)) {
                        AsyncImage(url: URL(string: item.mainPicture!.replacingOccurrences(of: "\"", with: ""))) { image in
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
                    .navigationTitle("Go")
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

//#Preview {
//    CatalogView(callback: {_ in}, manga: Manga)
//}
