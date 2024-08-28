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
        NavigationView {
            ZStack {
#if os(tvOS) // Canvas +TV style
                Image("ML65001")
                    .resizable()
                    .scaledToFit() // Scale to fill the entire screen, potentially cropping the image
                    .edgesIgnoringSafeArea(.all) // Extend the imag
#endif
                
                VStack(spacing: 32) {
#if !os(watchOS) && !os(tvOS)
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
                            case 4:
                                filter = .byDemographics
                            case 5:
                                filter = .byTheme
                            default:
                                break
                            }
                            switch result {
                            case 0, 1:
                                hideAuto = true
                            case 2, 3, 4, 5:
                                hideAuto = false
                            default:
                                break
                            }
                            Task {
                                options = try await vm.dealOptions(filter: filter)
                                content = !(options!.isEmpty) ? options![0] : ""
                                manga = try await vm.seed(per: vm.per, filter: filter, content: content)
                            }
                        }, options: ["All", "Best", "Author", "Genre", "Dmgrphc", "Theme"])
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
#endif
                    CatalogView(callback: { result in
                        if result == .forward {
                            manga = vm.deliverForward()
                        } else {
                            manga = vm.deliverBack()
                        }
                    }, manga: $manga)
                    
                    // Manga local
#if os(iOS)
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        MangaLocalView()
                    } else {
                        NavigationLink(destination: MangaLocalView()) {
                            Text("Local")
                        }
                    }
#elseif os(tvOS)
                Spacer()
                MangaLocalView()
#endif
                }
                .padding()
                .onAppear {
                    if !viewDidLoad {
                        viewDidLoad = true
                        Task {
                            var per = 4
#if os(watchOS)
                            per = 1
#elseif os(tvOS)
                            per = 3
#endif
                            manga = try await vm.seed(per: per, filter: .all, content: "")
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
