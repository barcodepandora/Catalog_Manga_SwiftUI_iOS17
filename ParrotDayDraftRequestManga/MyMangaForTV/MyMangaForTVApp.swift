//
//  MyMangaForTVApp.swift
//  MyMangaForTV
//
//  Created by Juan Manuel Moreno on 26/08/24.
//

import SwiftUI
import SwiftData

@main
struct MyMangaForTVApp: App {
    
    @StateObject private var vm = MangaViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(vm)
        }

//        WindowGroup {
//            ContentView()
//        }
    }
}
