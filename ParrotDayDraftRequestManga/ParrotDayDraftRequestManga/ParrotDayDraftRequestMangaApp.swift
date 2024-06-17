//
//  ParrotDayDraftRequestMangaApp.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 3/06/24.
//

import SwiftUI
import SwiftData

@main
struct ParrotDayDraftRequestMangaApp: App {
        
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Manga.self)
    }
}
