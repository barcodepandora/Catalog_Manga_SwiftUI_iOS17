//
//  MangaViewModel.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 3/06/24.
//

import Foundation

protocol MangaViewModelProtocol {
    
    // Catalog
    func passPage(page: Int, per: Int, filter: CatalogFilter, content: String) async throws -> Manga
    func search(page: Int, per: Int, text: String) async throws -> Manga
    func seed(per: Int, filter: CatalogFilter, content: String) async throws -> Manga
    func deliverForward() -> Manga
    func deliverBack() -> Manga
    
    // Options by category
    func dealOptions(filter: CatalogFilter) async throws -> [String]
    
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
    var content: String = ""
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
    func passPage(page: Int, per: Int, filter: CatalogFilter, content: String) async throws -> Manga {
        print(filter)
        var manga = try await useCase?.list(page: page, per: per, filter: filter, content: content)
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

    func seed(per: Int, filter: CatalogFilter, content: String) async throws -> Manga {
        mangaB = Manga()
        self.page = 1
        self.per = per
        self.filter = filter
        self.content = content
        manga = try await self.passPage(page: page, per: self.per, filter: self.filter, content: content)
        mangaF = try await self.passPage(page: page + 1, per: self.per, filter: self.filter, content: content)
        return manga!
    }
    
    func deliverForward() -> Manga {
        if !isAtLast() {
            mangaB = manga
            manga = mangaF
            page += 1
            Task {
                mangaF = try await self.passPage(page: page + 1, per: self.per, filter: self.filter, content: "")
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
                mangaB = try await self.passPage(page: page - 1, per: self.per, filter: self.filter, content: "")
            }
        }
        return manga!
    }
    
    // Options by category
    func dealOptions(filter: CatalogFilter) async throws -> [String] {
        var options: [String] = []
        switch filter {
        case .all:
            options = []
        case .bestMangas:
            options = []
        case .byAuthor:
            let authors = try await useCase!.dealAuthors(filter: filter)
            options = authors != nil ? authors.map { "\($0.firstName!) \($0.lastName!)" } as! [String] : []
        case .byGenre:
            let genres = try await useCase!.dealGenres(filter: filter)
            options = genres
        case .byDemographics:
            let demographics = try await useCase!.dealDemographics(filter: filter)
            options = demographics
        case .byTheme:
            let themes = try await useCase!.dealThemes(filter: filter)
            options = themes
        default:
            break
        }
        return options
    }
    
    // Local
    func dealManga() async throws -> Manga {
        return try await useCase!.dealManga()
    }
    
    func prepareMangaLocal() async throws -> [MangaLocal] {
        var mangas = [
            MangaLocalDTO(title: "Ganbare Kickers", userManga: UserMangaCollectionRequestDTO(manga: 65001)),
            MangaLocalDTO(title: "Gekko Kamen", userManga: UserMangaCollectionRequestDTO(manga: 65002, volumesOwned: [1, 2])),
            MangaLocalDTO(title: "Starzinger", userManga: UserMangaCollectionRequestDTO(manga: 65003, readingVolume: 1))
        ]
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
