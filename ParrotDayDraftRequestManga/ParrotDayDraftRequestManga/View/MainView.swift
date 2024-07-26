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

    @State private var page = 1
    @State private var per = 3
    @State private var text = "dra"
    @State var manga: Manga?
    @State var mangaF: Manga?
    @State var mangaB: Manga?
    @State var myManga: UserMangaCollectionRequestDTO?
    @State private var hasSwipped = false
    @State private var filter: CatalogFilter?
    @State private var mangaSwiftData: Manga?

        let options: [String] = ["Option 1", "Option 2"]
//        let clockSize: CGFloat = 200
//        let needleLength: CGFloat = 80
    
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
                            manga = try await vm.search(page: self.page, per: self.per, text: result)
                        }
                    }, vm: vm)
                    ClockView(callback: { result in
                        if result == .happy {
                            filter = .all
                        } else {
                            filter = .bestMangas
                        }
                        self.seed()
                    })

                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                            ForEach(deliverManga()) { item in
                                NavigationLink(destination: MangaView(mangaItem: item)) {
                                    AsyncImage(url: URL(string: item.mainPicture!.replacingOccurrences(of: "\"", with: ""))) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 125)
                                    } placeholder: {
                                        ProgressView()
                                            .controlSize(.extraLarge)
                                    } // Cuando acaba de cargar es como un Image
                                    .background {
                                        Color(white: 0.8)
                                    }
                                }
                                .navigationTitle("Go")
                            }
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width > 50 {
                                    deliverBack()
                                } else {
                                    deliverForward()
                                }
                                self.hasSwipped = true
                            }
                    )
                    .onChange(of: self.hasSwipped) { _ in
                    }
                    
                    // Manga local
                    NavigationLink(destination: MangaLocalView()) {
                        Text("Local")
                    }
                }
                .padding()
                .onAppear {
                    self.seed()
                }
    //            .ignoresSafeArea()
            }
            .navigationViewStyle(StackNavigationViewStyle())
    //        .edgesIgnoringSafeArea(.all)        }

    }
    
    func deliverManga() -> [Item] {
        if manga != nil && !manga!.items.isEmpty {
            return manga!.items
        } else {
            return [Item]()
        }
    }
    
    func seed() {
        mangaB = Manga()
        Task {
            var filter = CatalogFilter.bestMangas
            manga = try await vm.passPage(page: page, per: self.per, filter: filter)
            mangaF = try await vm.passPage(page: page + 1, per: self.per, filter: CatalogFilter.bestMangas)
        }
    }
    
    func deliverForward() {
        if !isAtLast() {
            mangaB = manga
            manga = mangaF
            page += 1
            Task {
                mangaF = try await vm.passPage(page: page + 1, per: self.per, filter: CatalogFilter.bestMangas)
//                modelContext.insert(mangaF!)
            }
        }
    }
    
    func deliverBack() {
        if !isAtFirst() {
            mangaF = manga
            manga = mangaB
            page -= 1
            Task {
                mangaB = try await vm.passPage(page: page - 1, per: self.per, filter: CatalogFilter.bestMangas)
            }
        }
    }
    
    func isAtFirst() -> Bool {
        return page == 1
    }
    
    func isAtLast() -> Bool {
        return (mangaF?.items.isEmpty)!
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
