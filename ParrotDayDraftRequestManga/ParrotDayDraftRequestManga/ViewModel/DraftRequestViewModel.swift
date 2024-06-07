//
//  DraftRequestViewModel.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 3/06/24.
//

import Foundation

protocol DraftRequestViewModelProtocol {
    func doIt()
    func passPage(page: Int, per: Int)
    func search(page: Int, per: Int, text: String)
}

class DraftRequestViewModel: DraftRequestViewModelProtocol {
    
    var useCase: DraftRequestUseCaseProtocol?
    
    init(useCase: DraftRequestUseCaseProtocol = DraftRequestUseCase()) {
        self.useCase = useCase
    }
    
    func doIt() {
        useCase?.doIt()
    }
    
    func passPage(page: Int, per: Int) {
        Task {
            try await useCase?.list(page: page, per: per)
        }
    }
    
    func search(page: Int, per: Int, text: String) {
        Task {
            try await useCase?.search(page: page, per: per, text: text)
        }
    }
}
