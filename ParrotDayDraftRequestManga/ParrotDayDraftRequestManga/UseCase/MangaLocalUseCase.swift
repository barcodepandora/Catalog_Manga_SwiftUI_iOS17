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
    func dealMangaLocalInTheCloud(mangas: [MangaLocalDTO]) async -> [MangaLocal]
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
        self.mangasLocal = await self.dealMangaLocalInTheCloud(mangas: mangas)
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
    
    func dealMangaLocalInTheCloud(mangas: [MangaLocalDTO]) async  -> [MangaLocal]{

#if !os(watchOS) && !os(tvOS)
        let db = Firestore.firestore()
        let ref = db.collection("mangas")
        return await withCheckedContinuation { continuation in
            ref.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error document: \(error)")
                }
                
                guard let documents = querySnapshot?.documents else { return }
                documents.forEach { document in
                    document.reference.delete { (error) in
                        if let error = error {
                            print("Error deleting document: \(error)")
                        } else {
                            print("Document deleted: \(document.documentID)")
                        }
                    }
                }

                if querySnapshot!.documents.isEmpty {
                    self.mangasLocal = self.fetchMangaLocalFromCache(mangas: mangas)
                    for manga in self.mangasLocal {
                        ref.document("manga").setData([
                            "title": manga.title,
                            "image": manga.image,
                            "completeCollection": manga.userManga.completeCollection,
                            "volumesOwned": manga.userManga.volumesOwned,
                            "readingVolume": manga.userManga.readingVolume
                        ]) { error in
                            if let error = error {
                                print("Error adding document: \(error)")
                            } 
                        }
                    }
                } else {
                    var index = 65001
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        self.mangasLocal.append(
                            MangaLocal(
                                title: document.get("title") as! String,
                                userManga: UserMangaCollectionRequest(
                                    manga: document.get("manga") != nil ? document.get("manga") as! Int: index,
                                    completeCollection: document.get("completeCollection") as! Bool,
                                    volumesOwned: document.get("volumesOwned") as! [Int]
                                ),
                                image: document.get("image") as! String
                            )
                        )
                        index += 1
                    }
                }
                continuation.resume(returning: self.mangasLocal)
            }
        }
#endif
    }
}
