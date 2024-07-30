//
//  MangaViewModel.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 3/06/24.
//

import Foundation

protocol MangaViewModelProtocol {
    
    // Catalog
    func passPage(page: Int, per: Int, filter: CatalogFilter) async throws -> Manga
    func search(page: Int, per: Int, text: String) async throws -> Manga
    func seed() async throws -> Manga
    func seed(per: Int, filter: CatalogFilter) async throws -> Manga
    func deliverForward() -> Manga
    func deliverBack() -> Manga
    
    // Local
    func dealManga() async throws -> Manga
    func prepareMangaLocal() async throws -> [MangaLocal]
    
    // User
    func login() async throws -> String
    
    // TODO
    func save(manga: UserMangaCollectionRequestDTO, token: String) async throws
}

@Observable
class MangaViewModel: MangaViewModelProtocol, ObservableObject {
    
    private var page = 1
    var per = 3
    private var text = "dra"
    var filter: CatalogFilter = .all
    var manga: Manga?
    var mangaF: Manga?
    var mangaB: Manga?

    @ObservationIgnored
    var useCase: MangaUseCaseProtocol?
    var mangaLocalUseCase: MangaLocalUseCaseProtocol?

    init(useCase: MangaUseCaseProtocol = MangaUseCase.shared, mangaLocalUseCase: MangaLocalUseCaseProtocol = MangaLocalUseCase.shared, manga: Manga? = Manga()) {
        self.useCase = useCase
        self.mangaLocalUseCase = mangaLocalUseCase
    }

    // Catalog
    func passPage(page: Int, per: Int, filter: CatalogFilter) async throws -> Manga {
        print(filter)
        var manga = try await useCase?.list(page: page, per: per, filter: filter)
        return manga!
    }
    
    func search(page: Int, per: Int, text: String) async throws -> Manga {
        var manga = try await useCase?.search(page: page, per: per, text: text)
        return manga!
    }
    
    func isAtLast() -> Bool {
        return (mangaF?.items.isEmpty)!
    }

    func isAtFirst() -> Bool {
        return page == 1
    }

    func seed() async throws -> Manga {
        mangaB = Manga()
        page = 1
        manga = try await self.passPage(page: page, per: self.per, filter: filter)
        mangaF = try await self.passPage(page: page + 1, per: self.per, filter: filter)
        return manga!
    }

    func seed(per: Int, filter: CatalogFilter) async throws -> Manga {
        mangaB = Manga()
        page = 1
        self.per = per
        self.filter = filter
        manga = try await self.passPage(page: page, per: self.per, filter: self.filter)
        mangaF = try await self.passPage(page: page + 1, per: self.per, filter: self.filter)
        return manga!
    }
    
    func deliverForward() -> Manga {
        if !isAtLast() {
            mangaB = manga
            manga = mangaF
            page += 1
            Task {
                mangaF = try await self.passPage(page: page + 1, per: self.per, filter: self.filter)
            }
        }
        return manga!
    }
    
    func deliverBack() -> Manga {
        if !isAtFirst() {
            mangaF = manga
            manga = mangaB
            page -= 1
            Task {
                mangaB = try await self.passPage(page: page - 1, per: self.per, filter: self.filter)
            }
        }
        return manga!
    }
    
    // Local
    func dealManga() async throws -> Manga {
        return try await useCase!.dealManga()
    }
    
    func prepareMangaLocal() async throws -> [MangaLocal] {
        var mangas = [MangaLocalDTO(title: "Ganbare Kickers", userManga: UserMangaCollectionRequestDTO(manga: 65000))]
        var mangasLocal = try await mangaLocalUseCase!.prepareMangaLocal(mangas: mangas)
        return mangasLocal
    }
    
    // User
    func login() async throws -> String {
        var token = try await useCase?.login()
        return token!
    }
    
    func save(manga: UserMangaCollectionRequestDTO, token: String) async throws {
        try await useCase?.save(manga: manga, token: token)
    }
}
