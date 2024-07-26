//
//  MangaViewModel.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 3/06/24.
//

import Foundation

protocol MangaViewModelProtocol {
    // Misc
    func doIt()
    
    // Catalog
    func passPage(page: Int, per: Int, filter: CatalogFilter) async throws -> Manga
    func search(page: Int, per: Int, text: String) async throws -> Manga
    func dealManga() async throws -> Manga
    func prepareMangaLocal() async throws -> [MangaLocal]
    
    // User
    func login() async throws -> String
    
    // TODO
    func save(manga: UserMangaCollectionRequestDTO, token: String) async throws
}

@Observable
class MangaViewModel: MangaViewModelProtocol, ObservableObject {
    
    @ObservationIgnored
    var useCase: MangaUseCaseProtocol?
    var mangaLocalUseCase: MangaLocalUseCaseProtocol?

    init(useCase: MangaUseCaseProtocol = MangaUseCase.shared, mangaLocalUseCase: MangaLocalUseCaseProtocol = MangaLocalUseCase.shared, manga: Manga? = Manga()) {
        self.useCase = useCase
        self.mangaLocalUseCase = mangaLocalUseCase
    }

    func doIt() {
        useCase?.doIt()
    }
    
    func passPage(page: Int, per: Int, filter: CatalogFilter) async throws -> Manga {
        print(filter)
        var manga = try await useCase?.list(page: page, per: per, filter: filter)
        return manga!
    }
    
    func search(page: Int, per: Int, text: String) async throws -> Manga {
        var manga = try await useCase?.search(page: page, per: per, text: text)
        return manga!
    }
    
    func dealManga() async throws -> Manga {
        return try await useCase!.dealManga()
    }
    
    func prepareMangaLocal() async throws -> [MangaLocal] {
        var mangas = [MangaLocalDTO(title: "Ganbare Kickers", userManga: UserMangaCollectionRequestDTO(manga: 65000))]
        var mangasLocal = try await mangaLocalUseCase!.prepareMangaLocal(mangas: mangas)
        return mangasLocal
    }
    
    func login() async throws -> String {
        var token = try await useCase?.login()
        return token!
    }
    
    func save(manga: UserMangaCollectionRequestDTO, token: String) async throws {
        try await useCase?.save(manga: manga, token: token)
    }
}
