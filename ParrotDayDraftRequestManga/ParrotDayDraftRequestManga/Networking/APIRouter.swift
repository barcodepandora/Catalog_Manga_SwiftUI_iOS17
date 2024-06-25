//
//  APIRouter.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 6/06/24.
//

import Foundation

class APIConstant {
    static let shared = APIConstant()
    
    // Manga
    let URLMangaAPI = "https://mymanga-acacademy-5607149ebe3d.herokuapp.com"
    let StringForList = "/list/mangas"
    let StringForSearchBegins = "/search/mangasBeginsWith/"
    
    // User
    let StringForLogin = "/users/login"
}

enum APIRouter {
    case get(page: Int? = 1, per: Int? = 20)
    case search(page: Int? = 1, per: Int? = 20, text: String? = "dragon")
    case post
    
    case login
    
    var url: URL {
        switch self {
        case .get(let page, let per):
            var parameters = URLComponents(string: APIConstant.shared.URLMangaAPI + APIConstant.shared.StringForList)
            parameters?.queryItems = [
                URLQueryItem(name: "page", value: String(page!)),
                URLQueryItem(name: "per", value: String(per!))
            ]
            return (parameters?.url!)!
        case .search(let page, let per, let text):
            var parameters = URLComponents(string: APIConstant.shared.URLMangaAPI + APIConstant.shared.StringForSearchBegins + text!)
            parameters?.queryItems = [
                URLQueryItem(name: "page", value: String(page!)),
                URLQueryItem(name: "per", value: String(per!)),
                URLQueryItem(name: "text", value: String(text!))
            ]
            return (parameters?.url!)!
        case .post:
            return URL(string: APIConstant.shared.URLMangaAPI + APIConstant.shared.StringForList)!
        case .login:
            return URL(string: APIConstant.shared.URLMangaAPI + APIConstant.shared.StringForLogin)!
        }
    }

    var method: String {
       switch self {
       case .get(_, _), .search(_, _, _):
           return "GET"
       case .post, .login:
           return "POST"
       }
   }

    var urlRequest: URLRequest {
        var urlRequest = URLRequest(url: self.url)
        urlRequest.httpMethod = self.method
        switch self {
        case .login:
            urlRequest.addValue("sLGH38NhEJ0_anlIWwhsz1-LarClEohiAHQqayF0FY", forHTTPHeaderField: "App-Token")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("Basic YmFyY29kZXBhbmRvcmFAZ21haWwuY29tOmw2YzZicjNyNmc=", forHTTPHeaderField: "Authorization")
        default:
            break
        }
        return urlRequest
    }
}
