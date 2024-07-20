//
//  MangaUseCase.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 3/06/24.
//

import Foundation
import SwiftUI
import SwiftData

protocol MangaUseCaseProtocol {
    func doIt()
    func list(page: Int, per: Int, filter: CatalogFilter) async throws -> Manga
    func search(page: Int, per: Int, text: String) async throws -> [Item]
    func dealManga() async throws -> Manga
    
    func login() async throws -> String
    func save(manga: UserMangaCollectionRequestDTO, token: String) async throws
}

class MangaUseCase: MangaUseCaseProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    private var mangaSwiftData: Manga
    
    @MainActor
    static let shared = MangaUseCase()
    
    @MainActor
    init() {
        self.modelContainer = ModelContainerForManga.modelContainer
        self.modelContext = modelContainer.mainContext
        self.mangaSwiftData = Manga()
    }
    
    func doIt() {
    }
    
    func list(page: Int, per: Int, filter: CatalogFilter) async throws -> Manga {
        var manga: Manga = Manga()
        var request: URLRequest
        
        switch filter {
        case .all:
            request = APIRouter.get(page: page, per: per).urlRequest
        case .bestMangas:
            request = APIRouter.bestMangas(page: page, per: per).urlRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            return Manga()
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            manga = try decoder.decode(MangaDTO.self, from: data).manga
            modelContext.insert(manga)
            return manga
        } catch {
            return manga
        }
    }
    
    func search(page: Int, per: Int, text: String) async throws -> [Item] {
        let (data, response) = try await URLSession.shared.data(for: APIRouter.search(page: page, per: per, text: text).urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            return []
        }
        let decoder = JSONDecoder()
        let a = try decoder.decode([Item].self, from: data)
        return a
    }
    
    func dealManga() async throws -> Manga {
        return fetchManga()
    }
        
    func fetchManga() -> Manga {
        var manga: Manga?
        do {
            let mangas = try modelContext.fetch(FetchDescriptor<Manga>())
            if !mangas.isEmpty { manga = mangas[0] }
        } catch {}
        return manga ?? Manga()
    }
    
    func login() async throws -> String {
        let (data, response) = try await URLSession.shared.data(for: APIRouter.login.urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            return ""
        }
        return String(data: data, encoding: .utf8)!
    }

    func save(manga: UserMangaCollectionRequestDTO, token: String) async throws {
        let (data, response) = try await URLSession.shared.data(for: APIRouter.save(manga: manga, token: token).urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }
        print(String(data: data, encoding: .utf8)!)
    }
}
