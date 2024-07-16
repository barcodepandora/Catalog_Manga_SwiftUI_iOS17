//
//  ModelContainerForManga.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 16/07/24.
//

import Foundation
import SwiftData

class ModelContainerForManga {
    static let modelContainer = try! ModelContainer(for: Manga.self, MangaLocal.self)
}
