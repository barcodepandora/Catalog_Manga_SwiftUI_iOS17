//
//  ContentView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 3/06/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("OK") { DraftRequestViewModel().doIt() }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
