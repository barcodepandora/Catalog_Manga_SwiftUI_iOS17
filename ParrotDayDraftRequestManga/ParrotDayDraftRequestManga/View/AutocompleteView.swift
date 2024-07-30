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
    @State private var text = ""

    init(callback: @escaping (String) -> Void, vm: MangaViewModel, placeholder: String? = nil, text: String = "dra") {
        self.callback = callback
        self.vm = vm
        self.text = text
    }
    var body: some View {
        TextField("Escribir", text: $text)
            .onChange(of: text) {
                callback(text)
            }
    }
}

#Preview {
    AutocompleteView(callback: {_ in }, vm: MangaViewModel(), placeholder: "")
}
