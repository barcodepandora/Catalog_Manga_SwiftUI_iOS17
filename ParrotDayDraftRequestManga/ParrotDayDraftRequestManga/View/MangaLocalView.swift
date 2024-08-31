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
    @State private var viewDidLoad = false
    
    init() {
        mangasLocal = deliverMangaLocal()
    }
    
    var body: some View {
        VStack {
            ScrollView {
                Text("My Manga Local")
                if (mangasLocal != nil && !mangasLocal!.isEmpty) {
                    CatalogViewLocal(mangasLocal: $mangasLocal)
                        .onAppear {
                            mangasLocal = deliverMangaLocal()
                    }
                } else {
                    Image("MacWatch")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 164, height: 164)
                        .animation(.easeInOut)
                    Text("Requesting from Cloud Firestore, A few delaying but so light and simple...")
                }
            }
        }
        .onAppear {
            if !viewDidLoad {
                viewDidLoad = true
                prepareMangaLocal()
            }  
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
