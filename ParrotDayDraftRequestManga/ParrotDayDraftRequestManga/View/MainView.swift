//
//  MainView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 26/06/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var vm: DraftRequestViewModel
    @Environment(\.modelContext) private var modelContext

    @State private var page = 1
    @State private var per = 3
    @State private var text = "dra"
    @State var manga: Manga?
    @State var mangaF: Manga?
    @State var myManga: UserMangaCollectionRequestDTO?
    @State private var hasSwipped = false
      
    var body: some View {
        NavigationView {
            VStack {
                
                // title
                Text("AC SDP 2024")
                
                // login
                Button(action: {
                    Task {
                        let token = try await vm.login()
                        print(token)
                        let data = token.data(using: .utf8)
                        let service = "com.uzupis.app"
                        let account = "JuanTune"
                        if KeychainButler.storeData(data: data!, forService: service, account: account) {
                            print("Security OK")
                        } else {
                            print("Security KO")
                        }
                    }
                }) {
                    Text("Renovar sesión")
                }
                
                // save manga
                Button(action: {
                    let service = "com.uzupis.app"
                    let account = "JuanTune"
                    if let retrieved = KeychainButler.retrieveData(forService: service, account: account) {
                        let token = String(data: retrieved, encoding: .utf8)
                        print(token)
                        Task {
                            try await vm.save(manga: UserMangaCollectionRequestDTO(manga: 42), token: token!)
                        }
                    } else {
                        print("KO")
                    }
                }) {
                    Text("Test collection manga")
                }
                
                // autocomplete
                TextField("Escribir", text: $text)
                    .onChange(of: text) {
                        debugPrint("Aqui vamos a pasar \(text)")
                        Task {
                            manga = Manga(items: try await vm.search(page: self.page, per: self.per, text: self.text))
                            modelContext.insert(manga!)
                        }
                    }
                
                // draft pagination
                Pager(action: { page in
                    Task {
                        manga = try await vm.passPage(page: page, per: self.per)
                        modelContext.insert(manga!)
                        mangaF = try await vm.passPage(page: page + 1, per: self.per)
                        modelContext.insert(mangaF!)

                    }
                })
                
                // list manga
//                List(manageItems()) { item in
//                    NavigationLink(destination: MangaView(mangaItem: item)) {
//                        Text(item.title!)
//                    }
//                    .navigationTitle("Go")
//                }
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                        ForEach(manageItems()) { item in
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
//                    .swipeActions(edge: .leading) {
//                        print("right")
//                    }
//                    .swipeActions(edge: .trailing) {
//                        print("left")
//                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            Task {
                                manga = mangaF
//                                m = try await vm.passPage(page: 1, per: 3)
    //                            if value.translation.width > 50 {
    //                                print("right")
    //                                page -= 1
    //                            } else {
    //                                page += 1
    //                                print("left")
    //                            }
    //                            if page > 0 {
    //                                var mangaT = try await vm.passPage(page: page, per: self.per)
    //                                if mangaT.items.count > 0 {
    //                                    manga = mangaT
    //                                    modelContext.insert(manga!)
    //                                } else {
    //                                    page -= 1
    //                                }
    //                                manga = try await vm.passPage(page: page, per: self.per)
    //                            } else {
    //                                page = 1
    //                            }
    //                            self.hasSwipped = true
                            }
                        }
                )
//                .onChange(of: self.hasSwipped) { _ in
//                    print("pasando")
//                }

            }
            .padding()
        }
        
    }
    
    func manageItems() -> [Item] {
            print("traeme \(manga)")
            if manga != nil && !manga!.items.isEmpty {
                return manga!.items
            } else {
                return [Item]()
            }
//            return [Item]()
    }
}

#Preview {
    MainView()
}
