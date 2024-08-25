//
//  MangaLocalUseCase.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 16/07/24.
//

import Foundation
import SwiftUI
import SwiftData

protocol MangaLocalUseCaseProtocol {
    func prepareMangaLocal(mangas: [MangaLocalDTO]) async throws -> [MangaLocal]
}

class MangaLocalUseCase: MangaLocalUseCaseProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = MangaLocalUseCase()
    
    @MainActor
    init() {
        self.modelContainer = ModelContainerForManga.modelContainer
        self.modelContext = modelContainer.mainContext
    }
    
    func prepareMangaLocal(mangas: [MangaLocalDTO]) async throws -> [MangaLocal] {
        var mangasLocal: [MangaLocal] = []
        self.cleanMangaLocal()
        for manga in mangas {
            var mangaLocal = manga.mangaLocal
            mangasLocal.append(mangaLocal)
            modelContext.insert(mangaLocal)
        }
        do {
            mangasLocal = try modelContext.fetch(FetchDescriptor<MangaLocal>())
            print(mangasLocal)
        } catch {
            fatalError(error.localizedDescription)
        }
        return mangasLocal
    }
    
    func cleanMangaLocal() {
        do {
            let mangasForRemove = try modelContext.fetch(FetchDescriptor<MangaLocal>())
            if !mangasForRemove.isEmpty {
                for manga in mangasForRemove {
                    modelContext.delete(manga)
                }
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
