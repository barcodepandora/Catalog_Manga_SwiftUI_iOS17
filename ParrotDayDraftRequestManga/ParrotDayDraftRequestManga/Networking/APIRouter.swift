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
    case bestMangas(page: Int? = 1, per: Int? = 20)
    case byGenre(page: Int? = 1, per: Int? = 20, content: String? = "")
    case search(page: Int? = 1, per: Int? = 20, text: String? = "dragon")
    case save(manga: UserMangaCollectionRequestDTO, token: String)
    case post
    case login
    

    var url: URL {
        var parameters = URLComponents(string: APIURL + self.path)
        switch self {
        case .get(let page, let per), .bestMangas(let page, let per), .byGenre(let page, let per, _), .search(let page, let per, _):
            parameters?.queryItems = [
                URLQueryItem(name: "page", value: String(page!)),
                URLQueryItem(name: "per", value: String(per!))
            ]
            return (parameters?.url!)!
        case .post, .login, .save:
            return URL(string: APIURL + self.path)!
        }
    }

    var path: String {
       switch self {
       case .get(_, _), .post:
           return "/list/mangas"
       case .bestMangas(_, _):
           return "/list/bestMangas"
       case .byGenre(let page, let per, let content):
           return "/list/mangaByGenre/" + content!
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
       case .get(_, _), .bestMangas(_, _), .byGenre(_, _, _), .search(_, _, _):
           return "GET"
       case .post, .save(_, _), .login:
           return "POST"
       }
   }

    var urlRequest: URLRequest {
        var urlRequest = URLRequest(url: self.url, cachePolicy:.useProtocolCachePolicy)
        urlRequest.httpMethod = self.method
        switch self {
        case .save(let manga, let token):
            let jsonBody: [String: Any] = [
                "manga": manga.manga,
                "completeCollection": manga.completeCollection,
                "volumesOwned": manga.volumesOwned,
                "readingVolume":  manga.readingVolume
            ]
            let jsonData = try! JSONSerialization.data(withJSONObject: jsonBody)
            urlRequest.httpBody = jsonData
            urlRequest.setValue("sLGH38NhEJ0_anlIWwhsz1-LarClEohiAHQqayF0FY", forHTTPHeaderField: "App-Token")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        case .login:
            let username = "barcodepandora@gmail.com"
            let password = "l6c6br3r6g"
            let authString = "\(username):\(password)"
            let authData = authString.data(using:.utf8)!
            let base64AuthString = authData.base64EncodedString()
            let jsonBody = [
                "email": "barcodepandora@gmail.com",
                "password": "l6c6br3r6g"
            ]
            let jsonData = try! JSONSerialization.data(withJSONObject: jsonBody)
            urlRequest.httpBody = jsonData
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("sLGH38NhEJ0_anlIWwhsz1-LarClEohiAHQqayF0FY", forHTTPHeaderField: "App-Token")
            urlRequest.setValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
        default:
            break
        }
        return urlRequest
    }
}
