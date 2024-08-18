//
//  MyMangaForWatchApp.swift
//  MyMangaForWatch Watch App
//
//  Created by Juan Manuel Moreno on 18/08/24.
//

import SwiftUI
import SwiftData

@main
struct MyMangaForWatch_Watch_AppApp: App {
    @StateObject private var vm = MangaViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(vm)
        }
    }

//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
}
