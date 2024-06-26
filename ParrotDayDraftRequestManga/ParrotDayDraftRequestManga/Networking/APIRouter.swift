//
//  APIRouter.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 6/06/24.
//

import Foundation

let APIURL = "https://mymanga-acacademy-5607149ebe3d.herokuapp.com"

enum APIRouter {
    case get(page: Int? = 1, per: Int? = 20)
    case search(page: Int? = 1, per: Int? = 20, text: String? = "dragon")
    case save(manga: UserMangaCollectionRequestDTO, token: String)
    case post
    case login
    

    var url: URL {
        var parameters = URLComponents(string: APIURL + self.path)
        switch self {
        case .get(let page, let per), .search(let page, let per, _):
            parameters?.queryItems = [
                URLQueryItem(name: "page", value: String(page!)),
                URLQueryItem(name: "per", value: String(per!))
            ]
            return (parameters?.url!)!
        case .save(let manga, let token):
            parameters?.queryItems = [
                URLQueryItem(name: "manga", value: String(manga.manga)),
                URLQueryItem(name: "completeCollection", value: String(manga.completeCollection)),
            ]
            return (parameters?.url!)!
        case .post, .login:
            return URL(string: APIURL + self.path)!
        }
    }

    var path: String {
       switch self {
       case .get(_, _), .post:
           return "/list/mangas"
       case .search(let page, let per, let text):
           return "/search/mangasBeginsWith/" + text!
       case .login:
           return "/users/login"
       case .save(_, _):
           return "/collection/manga"
       }
   }
    
    var method: String {
       switch self {
       case .get(_, _), .search(_, _, _):
           return "GET"
       case .post, .save(_, _), .login:
           return "POST"
       }
   }

    var urlRequest: URLRequest {
        var urlRequest = URLRequest(url: self.url)
        urlRequest.httpMethod = self.method
        switch self {
        case .save(let manga, let token):
            urlRequest.addValue(token, forHTTPHeaderField: "App-Token")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("Basic YmFyY29kZXBhbmRvcmFAZ21haWwuY29tOmw2YzZicjNyNmc=", forHTTPHeaderField: "Authorization")
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
