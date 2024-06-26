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
    @State private var text = "pok"
    @State private var token = ""
    @State var manga: Manga?
    @State var myManga: UserMangaCollectionRequestDTO?
    
    var body: some View {
        VStack {
            Text("AC SDP 2024")

            Button(action: {
                Task {
                    token = try await vm.login()
                    print(token)
                }
            }) {
                Text("Renovar sesión")
            }

            Button(action: {
                Task {
                    try await vm.save(manga: UserMangaCollectionRequestDTO(manga: 240624001), token: self.token)
                }
            }) {
                Text("Test collection manga")
            }
            
            TextField("Escribor", text: $text)
                .onChange(of: text) {
                    debugPrint("Aqui vamos a pasar \(text)")
                    Task {
                        manga = Manga(items: try await vm.search(page: self.page, per: self.per, text: self.text))
                        modelContext.insert(manga!)
                    }
                }
            
            Pager(action: { page in
                Task {
                    manga = try await vm.passPage(page: page, per: self.per)
                    modelContext.insert(manga!)
                }
            })
            
            List(manageItems()) { item in
                Text(item.title!)
            }
        }
        .padding()
        
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
