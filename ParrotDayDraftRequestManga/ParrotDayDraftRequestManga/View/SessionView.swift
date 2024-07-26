//
//  SessionView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 26/07/24.
//

import SwiftUI

struct SessionView: View {
    let vm: MangaViewModel

    var body: some View {
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
    }
}

#Preview {
    SessionView(vm: MangaViewModel())
}
