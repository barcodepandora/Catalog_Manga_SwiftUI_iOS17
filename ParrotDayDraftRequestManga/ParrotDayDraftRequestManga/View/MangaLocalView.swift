//
//  MangaLocalView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 20/07/24.
//

import SwiftUI

struct MangaLocalView: View {
    
    @EnvironmentObject private var vm: MangaViewModel
    @State private var mangasLocal: [MangaLocal]?
    
    init() {
        mangasLocal = deliverMangaLocal()
    }
    
    var body: some View {
        VStack {
            ScrollView {
                Text("My Manga Local")
                CatalogViewLocal(mangasLocal: $mangasLocal)
                    .onAppear {
                        mangasLocal = deliverMangaLocal()
                }
            }
        }
        .onAppear {
            prepareMangaLocal()
        }
        
    }
    
    func prepareMangaLocal() {
        Task {
            self.mangasLocal = try await self.vm.prepareMangaLocal()
        }
    }

    func deliverMangaLocal() -> [MangaLocal] {
        if mangasLocal != nil && !mangasLocal!.isEmpty {
            return mangasLocal!
        } else {
            return []
        }
    }
}

#Preview {
    MangaLocalView()
}
