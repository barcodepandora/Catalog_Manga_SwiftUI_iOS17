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

    @State private var selection: Double = 0

        let options: [String] = ["Option 1", "Option 2"]
        let clockSize: CGFloat = 200
        let needleLength: CGFloat = 80
    
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
                        }
                    }
                ZStack {
                    Circle()
                        .stroke(Color.gray, lineWidth: 2)
                        .frame(width: clockSize, height: clockSize)

                    // Needle
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 2, height: needleLength)
                        .rotationEffect(Angle(degrees: selection * 36))
                        .animation(.easeInOut)

                    // Center dot
                    Circle()
                        .fill(Color.black)
                        .frame(width: 10, height: 10)

                    // Option labels
//                    ForEach(0..<options.count, id: \.self) { index in
//                        Text(options[index])
//                            .rotationEffect(Angle(degrees: Double(index) * 36))
//                            .offset(y: clockSize / 2 - 20)
//                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            print("\(value.translation.width), \(value.translation.height)")
//                            let angle = atan2(value.translation.width, value.translation.height) * 180 / .pi
                            let angle = 180
                            if value.translation.width > 50 {
                                filter = .all
                            } else {
                                filter = .bestMangas
                            }
                            self.seed()
//                            let selection = (angle + 180) / 36
//                            self.selection = selection.truncatingRemainder(dividingBy: Double(options.count))
                        }
                )
            
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
        }
    }
    
    func deliverManga() -> [Item] {
        if manga != nil && !manga!.items.isEmpty {
            return manga!.items
        } else {
            return [Item]()
        }
    }
    
    func seed() {
//        self.prepareMangaLocal()
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
    
//    func prepareMangaLocal() {
//        Task {
//            self.mangaslocal = try await self.vm.prepareMangaLocal()
//        }
//    }
//
//    func deliverMangaLocal() -> [MangaLocal] {
//        if mangaslocal != nil && !mangaslocal!.items.isEmpty {
//            return mangaslocal!.items
//        } else {
//            return []
//        }
//    }
}

#Preview {
    MainView()
}
