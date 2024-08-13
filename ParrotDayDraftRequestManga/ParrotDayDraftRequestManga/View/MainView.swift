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
    @State var myManga: UserMangaCollectionRequestDTO?
    @State private var mangaSwiftData: Manga?
    @State private var viewDidLoad = false
    @State private var hideAuto = true
    
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
                VStack(spacing: 32) {
//                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center, spacing: 13) {
                            ClockView(selection: 4, callback: { result in
                                var per = result
                                Task {
                                    manga = try await vm.seed(per: per, filter: vm.filter, content: vm.content)
                                }
                            }, options: ["0pp", "1pp", "2pp", "3pp", "4pp", "5pp"])
                            ClockView(callback: { result in
                                var filter: CatalogFilter = .all
                                var content = ""
                                switch result {
                                case 0:
                                    filter = .all
                                case 1:
                                    filter = .bestMangas
                                case 2:
                                    filter = .byAuthor
                                case 3:
                                    filter = .byGenre
                                default:
                                    break
                                }
                                switch result {
                                case 0, 1:
                                    hideAuto = true
                                case 2, 3:
                                    hideAuto = false
                                default:
                                    break
                                }
                                Task {
                                    options = try await vm.dealOptions(filter: filter)
                                    content = !(options!.isEmpty) ? options![0] : ""
                                    manga = try await vm.seed(per: vm.per, filter: filter, content: content)
                                }
                            }, options: ["All", "Best", "Author", "Genre"])
                        }
//                    }
//                    .padding(.horizontal)

//                    SessionView(vm: vm)
//                    SaveMangaLocalView(vm: vm)
                    
                    HStack {
                        AutocompleteView(callback: { result in
                            Task {
                                manga = try await vm.search(page: 1, per: vm.per, text: result)
                            }
                        }, vm: vm, placeholder: "Escribir titulo")

                        if !(hideAuto) {
                            AutocompleteView(callback: { result in
                                let index = options!.contains { $0.contains(result) }
                                if index {
                                    print(result)
                                    Task {
                                        manga = try await vm.seed(per: vm.per, filter: vm.filter, content: result)
                                    }
                                }
                            }, vm: vm, placeholder: "Escribir opcion por categoria")
                        }
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
                    if !viewDidLoad {
                        viewDidLoad = true
                        Task {
                            manga = try await vm.seed(per: 4, filter: .all, content: "")
                        }
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
