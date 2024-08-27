//
//  CatalogViewLocal.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 25/08/24.
//

import SwiftUI

struct ItemForCatalogLocal: View {
    var item: MangaLocal
    
    init(item: MangaLocal) {
        self.item = item
    }
    
    var body: some View {
//        NavigationLink(destination: ContentView() ) {
            VStack {
                ZStack {
                    AsyncImage(url: URL(string: item.image.replacingOccurrences(of: "\"", with: ""))) { image in
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
                    CircularTextView(title: item.title, radius: 78)
                }
                .background {
                    Color(white: 1)
                }
            }
//        }
//        .navigationTitle("My Manga")
//#if !os(watchOS) && !os(tvOS)
//        .navigationBarTitleDisplayMode(.inline)
//#endif
//        .font(.custom("Arial", size: 14))
    }
}

struct CatalogViewLocal: View {
    //    let callback: (Direction) -> Void
    
    @Binding var mangasLocal: [MangaLocal]?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                ForEach(Array(mangasLocal?.compactMap { $0 } ?? []), id: \.id) { item in
                    ItemForCatalogLocal(item: item)
                }
            }
        }
    }
}

//#Preview {
//    CatalogViewLocal()
//}
