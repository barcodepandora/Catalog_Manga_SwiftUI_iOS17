//
//  ContentView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 3/06/24.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext

    @State private var page = 1
    @State private var per = 3
    @State private var text = "pok"
    
    @State var manga: Manga?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Este es el protecto final de AC SDP 2024")
            Pager(action: { page in
                Task {
                    
                    manga = try await DraftRequestViewModel().passPage(page: page, per: self.per)
                    modelContext.insert(manga!)
                }
                
                
            })
        }
        .padding()
        
    }
}


#Preview {
    ContentView()
}
