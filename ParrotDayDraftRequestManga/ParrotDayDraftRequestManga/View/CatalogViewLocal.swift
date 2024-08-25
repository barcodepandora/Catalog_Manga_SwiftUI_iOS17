//
//  CatalogViewLocal.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 25/08/24.
//

import SwiftUI

struct CatalogViewLocal: View {
//    let callback: (Direction) -> Void
    
    @Binding var mangasLocal: [MangaLocal]?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                ForEach(Array(mangasLocal?.compactMap { $0 } ?? []), id: \.id) { item in
//                    NavigationLink(destination: MangaView(mangaItem: item)) {
                        VStack {
                            ZStack {
                                Image(item.image)
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
//                                AsyncImage( (url: URL(string: item.image)) { image in
//                                    // Display the loaded image
//                                    image
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 93, height: 109)
//                                        .aspectRatio(contentMode: .fit)
//                                        .clipShape(Circle())
//                                        .overlay(
//                                            Circle()
//                                                .stroke(Color.white, lineWidth: 2)
//                                        )
//                                        .shadow(radius: 5)
//                                } placeholder: {
//                                    Image("MacWatch")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 50, height: 50)
//                                        .animation(.easeInOut)
//
//                                }
                                .background {
                                    Color(white: 1)
                                }
                                CircularTextView(title: item.title, radius: 78)
                            }
                            .background {
                                Color(white: 1)
                            }
                        }
//                    }
//                    .navigationTitle("MyManga")
//                    .navigationBarTitleDisplayMode(.inline)
//                    .font(.custom("Arial", size: 14))
                }
            }
        }
//        .gesture(
//            DragGesture()
//                .onEnded { value in
//                    let direction: Direction
//                    if value.translation.width > 50 {
//                        direction = .back
//                    } else {
//                        direction = .forward
//                    }
//                    callback(direction)
//                }
//        )
    }
    
//    func deliverManga() -> [Item] {
//        if manga != nil && !manga!.items.isEmpty {
//            return manga!.items
//        } else {
//            return [Item]()
//        }
//    }
}

//#Preview {
//    CatalogViewLocal()
//}
