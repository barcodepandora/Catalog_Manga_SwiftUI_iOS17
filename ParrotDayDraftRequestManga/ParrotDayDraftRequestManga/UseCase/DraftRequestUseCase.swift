//
//  DraftRequestUseCase.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 3/06/24.
//

import Foundation

protocol DraftRequestUseCaseProtocol {
    func doIt()
}

class DraftRequestUseCase: DraftRequestUseCaseProtocol {
    func doIt() {
        Clerk().greet(idol: IdolOfLeague(name: "Elena"))
    }
}

protocol IdolProtocol {
    var name: String { get }
    
    func greet()
}

class IdolOfImas: IdolProtocol {
    var name: String
    
    init(name: String? = nil) {
        self.name = name!
    }
    
    func greet() {
        print("お早う \(name)")
    }
}

class IdolOfLeague: IdolProtocol {
    var name: String
    
    init(name: String? = nil) {
        self.name = name!
    }
    
    func greet() {
        print("مرحبا \(name)")
    }
}

class Clerk<T> {
    func greet(idol: T) where T: IdolProtocol {
        idol.greet()
    }
}
