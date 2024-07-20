//
//  MangaLocalView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 20/07/24.
//

import SwiftUI

struct MangaLocalView: View {
    
    @EnvironmentObject private var vm: MangaViewModel
    @State var mangasLocal: [MangaLocal]?
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                    ForEach(deliverMangaLocal()) { item in
                        Text("\(item.title)")
                    }
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
