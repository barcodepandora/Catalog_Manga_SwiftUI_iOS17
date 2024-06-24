//
//  DraftRequestUseCase.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 3/06/24.
//

import Foundation
import SwiftUI

protocol DraftRequestUseCaseProtocol {
    func doIt()
    func list(page: Int, per: Int) async throws -> Manga
    func search(page: Int, per: Int, text: String) async throws -> [Item]
    func save(item: Item)
}

class DraftRequestUseCase: DraftRequestUseCaseProtocol {
    
    func doIt() {
        Clerk().greet(idol: IdolOfLeague(name: "Elena"))
    }
    
    func list(page: Int, per: Int) async throws -> Manga {
        var manga: Manga = Manga()
        
        let (data, response) = try await URLSession.shared.data(for: APIRouter.get(page: page, per: per).urlRequest)
//        let (data, response) = try await URLSession.shared.data(from: URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/list/mangas?page=1&per=3")!)
    
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return Manga()
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            manga = try decoder.decode(MangaDTO.self, from: data).manga
            debugPrint(data)
            debugPrint(response)
            return manga
        } catch {
            print(error)
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
        print(a)
        return a
    }
    
    func save(item: Item) {
        
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
