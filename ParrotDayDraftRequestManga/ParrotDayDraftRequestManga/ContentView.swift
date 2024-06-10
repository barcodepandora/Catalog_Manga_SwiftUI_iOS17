//
//  ContentView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 3/06/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var page = 1
    @State private var per = 3
    @State private var text = "pok"
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Este es el protecto final de AC SDP 2024")
            Pager(action: { page in
                DraftRequestViewModel().passPage(page: page, per: self.per)
            })
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
