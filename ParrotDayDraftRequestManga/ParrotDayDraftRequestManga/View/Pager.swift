//
//  Pager.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 10/06/24.
//

import SwiftUI

struct Pager: View {
    
    let pages: [Page] = [Page(id: 1, desc: "1"), Page(id: 2, desc: "2"), Page(id: 3, desc: "3")]
    var action: (_ page: Int) -> Void
    
    var body: some View {
        List (pages) { page in
            HStack {
                Button(action: {
                    self.action(page.id!)
                }) {
                    Text("No. \(page.desc!)")
                }
            }
        }
    }
}

#Preview {
    Pager(action: { page in print("OK") })
}
