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
    @State var myManga: UserMangaCollectionRequestDTO?
    
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
                    }
                })
                
                // list manga
//                NavigationView {
                    List(manageItems()) { item in
                        NavigationLink(destination: MangaView(mangaItem: item)) {
                            Text(item.title!)
                        }
                        .navigationTitle("Go")
                    }
//                }
            }
            .padding()
        }
        
    }
    
    func manageItems() -> [Item] {
        if manga != nil && !manga!.items.isEmpty {
            return manga!.items
        } else {
            return [Item]()
        }
    }
}

#Preview {
    MainView()
}
