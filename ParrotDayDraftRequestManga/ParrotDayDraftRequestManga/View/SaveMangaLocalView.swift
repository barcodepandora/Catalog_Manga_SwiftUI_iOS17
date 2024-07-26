//
//  SaveMangaLocalView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 26/07/24.
//

import SwiftUI

struct SaveMangaLocalView: View {
    let vm: MangaViewModel
    
    var body: some View {
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
    }
}

#Preview {
    SaveMangaLocalView(vm: MangaViewModel())
}
