//
//  FavoriteView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 4/08/24.
//

import SwiftUI

struct FavoriteView: View {
    
    private var item: Item
    
    init(item: Item) {
        self.item = item
    }
    
    var body: some View {
        Button(action: { item.isFavorite.toggle() } ) {
            Image(systemName: item.isFavorite ? "star.fill" : "star")
        }
    }
}

#Preview {
    FavoriteView(item: Item())
}
