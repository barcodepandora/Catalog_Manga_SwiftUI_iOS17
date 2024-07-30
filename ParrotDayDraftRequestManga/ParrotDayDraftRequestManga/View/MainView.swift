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
//                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center, spacing: 13) {
                            ClockPerView(callback: { result in
                                var per = result
                                Task {
                                    manga = try await vm.seed(per: per, filter: vm.filter)
                                }
                            })
                            ClockPerView(callback: { result in
                                var per = result
                                Task {
                                    manga = try await vm.seed(per: per, filter: vm.filter)
                                }
                            })
                            ClockView(callback: { result in
                                var filter: CatalogFilter = .all
                                switch result {
                                case 0:
                                    filter = .all
                                case 1:
                                    filter = .bestMangas
                                case 2:
                                    filter = .byGenre
                                default:
                                    break
                                }
                                Task {
                                    manga = try await vm.seed(per: vm.per, filter: filter)
                                }
                            })
                        }
//                    }
//                    .padding(.horizontal)

//                    SessionView(vm: vm)
//                    SaveMangaLocalView(vm: vm)

                    HStack {
                        AutocompleteView(callback: { result in
                            Task {
                                manga = try await vm.passPage(page: 1, per: vm.per, filter: vm.filter, content: result)
                            }
                        }, vm: vm, placeholder: "Escribir categoria")
                        AutocompleteView(callback: { result in
                            Task {
                                manga = try await vm.search(page: 1, per: vm.per, text: result)
                            }
                        }, vm: vm, placeholder: "Escribir titulo")
                    }

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
                        manga = try await vm.seed(per: 4, filter: .all)
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
