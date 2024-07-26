//
//  AutocompleteView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 26/07/24.
//

import SwiftUI

struct AutocompleteView: View {
    let callback: (String) -> Void
    
    let vm: MangaViewModel
    @State private var text = "dra"

    var body: some View {
        TextField("Escribir", text: $text)
            .onChange(of: text) {
                callback(text)
            }
    }
}

#Preview {
    AutocompleteView(callback: {_ in }, vm: MangaViewModel())
}
