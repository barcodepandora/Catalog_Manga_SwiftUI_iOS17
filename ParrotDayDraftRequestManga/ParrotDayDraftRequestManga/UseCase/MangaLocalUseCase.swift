//
//  MangaLocalUseCase.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 16/07/24.
//

import Foundation
import SwiftUI
import SwiftData

#if !os(watchOS) && !os(tvOS)
import Firebase
import FirebaseFirestore
#endif

protocol MangaLocalUseCaseProtocol {
    func prepareMangaLocal(mangas: [MangaLocalDTO]) async throws -> [MangaLocal]
    func insertMangaLocalIntoCache(mangas: [MangaLocalDTO])
    func fetchMangaLocalFromCache(mangas: [MangaLocalDTO]) -> [MangaLocal]
    func insertMangaLocalInDaCloud(mangas: [MangaLocalDTO])
}

class MangaLocalUseCase: MangaLocalUseCaseProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    private var mangasLocal: [MangaLocal] = []
    
    @MainActor
    static let shared = MangaLocalUseCase()
    
    @MainActor
    init() {
        self.modelContainer = ModelContainerForManga.modelContainer
        self.modelContext = modelContainer.mainContext
    }
    
    func prepareMangaLocal(mangas: [MangaLocalDTO]) async throws -> [MangaLocal] {
        self.cleanMangaLocal()
        self.insertMangaLocalIntoCache(mangas: mangas)
        self.mangasLocal = self.fetchMangaLocalFromCache(mangas: mangas)
        self.insertMangaLocalInDaCloud(mangas: mangas)
        return self.mangasLocal
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
    
    func insertMangaLocalIntoCache(mangas: [MangaLocalDTO]) {
        for manga in mangas {
            var mangaLocal = manga.mangaLocal
            mangasLocal.append(mangaLocal)
            modelContext.insert(mangaLocal)
        }
    }
    
    func fetchMangaLocalFromCache(mangas: [MangaLocalDTO]) -> [MangaLocal] {
        var mangasLocal: [MangaLocal] = []
        do {
            mangasLocal = try modelContext.fetch(FetchDescriptor<MangaLocal>())
            print(mangasLocal)
        } catch {
            fatalError(error.localizedDescription)
        }
        return mangasLocal
    }
    
    func insertMangaLocalInDaCloud(mangas: [MangaLocalDTO]) {
#if !os(watchOS) && !os(tvOS)
        // Get a reference to the Firestore database
        let db = Firestore.firestore()
        
        // You can also use db.collection("users").document("someUserId") if you want to specify the document ID
        // Here, we're letting Firestore auto-generate the document ID
        var ref: DocumentReference? = nil
        for manga in mangas {
            ref = db.collection("mangas").addDocument(data: [
                "title": manga.title,
                "image": manga.image,
                "completeCollection": manga.userManga.completeCollection,
                "volumesOwned": manga.userManga.volumesOwned,
                "readingVolume": manga.userManga.readingVolume
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
#endif
    }
}
