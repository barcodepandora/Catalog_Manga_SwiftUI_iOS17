//
//  DraftRequestViewModel.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 3/06/24.
//

import Foundation

protocol DraftRequestViewModelProtocol {
    func doIt()
    func passPage(page: Int, per: Int) async throws -> Manga
    func search(page: Int, per: Int, text: String) async throws -> [Item]
    func save(item: Item)
}

class DraftRequestViewModel: DraftRequestViewModelProtocol {
    
    var useCase: DraftRequestUseCaseProtocol?
    
    init(useCase: DraftRequestUseCaseProtocol = DraftRequestUseCase()) {
        self.useCase = useCase
    }
    
    func doIt() {
        useCase?.doIt()
    }
    
    func passPage(page: Int, per: Int) async throws -> Manga {
            var manga = try await useCase?.list(page: page, per: per)
            print(manga)
            return manga!
    }
    
    func search(page: Int, per: Int, text: String) async throws -> [Item] {
        var manga = try await useCase?.search(page: page, per: per, text: text)
        print(manga)
        return manga!

    }
    
    func save(item: Item) {
        
    }
}
