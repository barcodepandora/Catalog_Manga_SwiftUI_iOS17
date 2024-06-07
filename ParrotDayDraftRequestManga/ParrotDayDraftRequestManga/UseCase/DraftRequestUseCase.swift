//
//  DraftRequestUseCase.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 3/06/24.
//

import Foundation

protocol DraftRequestUseCaseProtocol {
    func doIt()
    
    func readManga() async throws
}

class DraftRequestUseCase: DraftRequestUseCaseProtocol {
    func doIt() {
        Clerk().greet(idol: IdolOfLeague(name: "Elena"))
        Task {
            try await readManga()
        }
    }
    
    func readManga() async throws {
        let (data, response) = try await URLSession.shared.data(for: APIRouter.get().urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }
        let decoder = JSONDecoder()
        let a = try decoder.decode(Manga.self, from: data)
        print(a)
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
