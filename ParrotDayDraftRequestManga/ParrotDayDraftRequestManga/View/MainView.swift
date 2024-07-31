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
    @State var options: [String]?
    @State var authors: [Author]?
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
                            ClockView(callback: { result in
                                var per = result
                                Task {
                                    manga = try await vm.seed(per: per, filter: vm.filter)
                                }
                            }, options: ["1", "2", "3", "4", "5", "6"])
                            ClockView(callback: { result in
                                var filter: CatalogFilter = .all
                                switch result {
                                case 0:
                                    filter = .all
                                case 1:
                                    filter = .bestMangas
                                case 2:
                                    filter = .byGenre
                                case 2:
                                    filter = .byAuthor
                                default:
                                    break
                                }
                                Task {
                                    options = try await vm.dealOptions(filter: filter)
                                    manga = try await vm.seed(per: vm.per, filter: filter)
                                }
                            }, options: ["All", "Best", "Genre", "Author"])
                        }
//                    }
//                    .padding(.horizontal)

//                    SessionView(vm: vm)
//                    SaveMangaLocalView(vm: vm)

                    HStack {
                        AutocompleteView(callback: { result in
                            let index = options!.contains { $0.contains(result) }
                            if index {
                                print(result)
                                Task {
                                    manga = try await vm.passPage(page: 1, per: vm.per, filter: vm.filter, content: result)
                                }
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
    
    func dealOptionsCache() -> [String] {
        var res = authors != nil ? Array((authors?.prefix(19))!).map { $0.firstName } as! [String] : []
        return res
    }
}

#Preview {
    MainView()
}
