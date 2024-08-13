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
    private var placeholder: String?

    init(callback: @escaping (String) -> Void, vm: MangaViewModel, placeholder: String? = nil, text: String = "dra") {
        self.callback = callback
        self.vm = vm
        self.text = text
        self.placeholder = placeholder!
    }
    var body: some View {
        TextField(placeholder!, text: $text)
            .padding(.leading, 36) // add padding to make room for the lens icon
                .padding(.trailing, 8)
                    .padding(.vertical, 8)
            .background(
                ZStack(alignment: .leading) {
                    Color.cyan
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 20)
                        .foregroundColor(.black)
                        .frame(width: 20, height: 20)
//                        .padding(.leading, -34)
                }
            )
            .cornerRadius(10)
            .onChange(of: text) {
                callback(text)
            }
    }
}

#Preview {
    AutocompleteView(callback: {_ in }, vm: MangaViewModel(), placeholder: "")
}
