//
//  MainView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 26/06/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    @EnvironmentObject private var vm: MangaViewModel
    @State var manga: Manga?
    @State var myManga: UserMangaCollectionRequestDTO?
    @State private var filter: CatalogFilter?
    @State private var mangaSwiftData: Manga?
    
    var body: some View {
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            VStack {
//            }
//            .padding()
//            .onAppear {
//                self.seed()
//            }
//            .ignoresSafeArea()        } else {
            NavigationView {
                VStack {
                    SessionView(vm: vm)
                    SaveMangaLocalView(vm: vm)
                    AutocompleteView(callback: { result in
                        Task {
                            manga = try await vm.search(page: 1, per: 3, text: result)
                        }
                    }, vm: vm)
                    ClockView(callback: { result in
                        if result == .happy {
                            filter = .all
                        } else {
                            filter = .bestMangas
                        }
                        Task {
                            manga = try await vm.seed()
                        }
                    })
                    CatalogView(callback: { result in
                        if result == .forward {
                            manga = vm.deliverForward()
                        } else {
                            manga = vm.deliverBack()
                        }
                    }, manga: $manga)
                    
                    // Manga local
                    NavigationLink(destination: MangaLocalView()) {
                        Text("Local")
                    }
                }
                .padding()
                .onAppear {
                    Task {
                        manga = try await vm.seed()
                    }
                }
    //            .ignoresSafeArea()
            }
            .navigationViewStyle(StackNavigationViewStyle())
    //        .edgesIgnoringSafeArea(.all)        }

    }
        
    func dealManga() {
        Task {
            self.mangaSwiftData = try await self.vm.dealManga()
        }
    }
}

#Preview {
    MainView()
}
