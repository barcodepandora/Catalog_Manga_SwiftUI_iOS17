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
    
    // Manga
    func list(page: Int, per: Int, filter: CatalogFilter, content: String) async throws -> Manga
    func search(page: Int, per: Int, text: String) async throws -> Manga
    func dealManga() async throws -> Manga
    
    // Options by category
    func dealAuthors(filter: CatalogFilter) async throws -> [Author]
    func dealGenres(filter: CatalogFilter) async throws -> [String]
    
    // Admin
    func login() async throws -> String
    func save(manga: UserMangaCollectionRequestDTO, token: String) async throws
}

class MangaUseCase: MangaUseCaseProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    private var mangaSwiftData: Manga
    let decoder = JSONDecoder()

    @MainActor
    static let shared = MangaUseCase()
    
    @MainActor
    init() {
        self.modelContainer = ModelContainerForManga.modelContainer
        self.modelContext = modelContainer.mainContext
        self.mangaSwiftData = Manga()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // Data
    func isResponseLegal(response: URLResponse) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse else {
            return false
        }
        guard (200..<300) ~= httpResponse.statusCode else {
            print("HTTP status code: \(httpResponse.statusCode)")
            return false
        }
        return true
    }
    
    // Manga
    func list(page: Int, per: Int, filter: CatalogFilter, content: String) async throws -> Manga {
        var request: URLRequest
        switch filter {
        case .all:
            request = APIRouter.get(page: page, per: per).urlRequest
        case .bestMangas:
            request = APIRouter.bestMangas(page: page, per: per).urlRequest
        case .byAuthor:
            request = APIRouter.byAuthor(page: page, per: per, content: content).urlRequest
        case .byGenre:
            request = APIRouter.byGenre(page: page, per: per, content: content).urlRequest
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        if !isResponseLegal(response: response) { return Manga() }
        do {
            let manga = try decoder.decode(MangaDTO.self, from: data).manga
            modelContext.insert(manga)
            return manga
        } catch {
            return Manga()
        }
    }
    
    func search(page: Int, per: Int, text: String) async throws -> Manga {
        let (data, response) = try await URLSession.shared.data(for: APIRouter.search(page: page, per: per, text: text).urlRequest)
        if !isResponseLegal(response: response) { return Manga() }
        let a = try decoder.decode([Item].self, from: data)
        var manga = Manga(metadata: MangaInfo(), items: a)
        modelContext.insert(manga)
        return manga
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
    
    // Options by category
    func dealAuthors(filter: CatalogFilter) async throws -> [Author] {
        var request: URLRequest
        request = APIRouter.authors.urlRequest
        let (data, response) = try await URLSession.shared.data(for: request)
        if !isResponseLegal(response: response) { return [] }
        do {
            let authors = try decoder.decode([Author].self, from: data)
            return authors
        } catch {
            return []
        }
    }
    
    func dealGenres(filter: CatalogFilter) async throws -> [String] {
        var request: URLRequest
        request = APIRouter.genres.urlRequest
        let (data, response) = try await URLSession.shared.data(for: request)
        if !isResponseLegal(response: response) { return [] }
        do {
            let genres = try decoder.decode([String].self, from: data)
            return genres
        } catch {
            return []
        }
    }
    
    func login() async throws -> String {
        let (data, response) = try await URLSession.shared.data(for: APIRouter.login.urlRequest)
        if !isResponseLegal(response: response) { return "" }
        return String(data: data, encoding: .utf8)!
    }

    func save(manga: UserMangaCollectionRequestDTO, token: String) async throws {
        let (data, response) = try await URLSession.shared.data(for: APIRouter.save(manga: manga, token: token).urlRequest)
        if !isResponseLegal(response: response) { return }
        print(String(data: data, encoding: .utf8)!)
    }
}
