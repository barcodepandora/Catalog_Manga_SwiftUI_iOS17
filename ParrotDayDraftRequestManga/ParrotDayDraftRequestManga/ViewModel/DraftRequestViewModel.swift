//
//  DraftRequestViewModel.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 3/06/24.
//

import Foundation

protocol DraftRequestViewModelProtocol {
    
    // Misc
    func doIt()
    
    // Catalog
    func passPage(page: Int, per: Int, filter: CatalogFilter) async throws -> Manga
    func search(page: Int, per: Int, text: String) async throws -> [Item]
    
    // User
    func login() async throws -> String
    
    // TODO
    func save(manga: UserMangaCollectionRequestDTO, token: String) async throws
}

class DraftRequestViewModel: DraftRequestViewModelProtocol, ObservableObject {
    
    var useCase: DraftRequestUseCaseProtocol?
    
    init(useCase: DraftRequestUseCaseProtocol = DraftRequestUseCase()) {
        self.useCase = useCase
    }
    
    func doIt() {
        useCase?.doIt()
    }
    
    func passPage(page: Int, per: Int, filter: CatalogFilter) async throws -> Manga {
        print(filter)
        var manga = try await useCase?.list(page: page, per: per, filter: filter)
        return manga!
    }
    
    func search(page: Int, per: Int, text: String) async throws -> [Item] {
        var manga = try await useCase?.search(page: page, per: per, text: text)
        return manga!

    }
    
    func login() async throws -> String {
        var token = try await useCase?.login()
        return token!
    }
    
    func save(manga: UserMangaCollectionRequestDTO, token: String) async throws {
        try await useCase?.save(manga: manga, token: token)
    }
}
