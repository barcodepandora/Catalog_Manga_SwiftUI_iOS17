//
//  ParrotDayDraftRequestMangaApp.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 3/06/24.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct ParrotDayDraftRequestMangaApp: App {
        
    @StateObject private var vm = MangaViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(vm)
        }
    }
}
