//
//  APIRouter.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 6/06/24.
//

import Foundation

class APIConstant {
    static let shared = APIConstant()
    
    let URLMangaAPI = "https://mymanga-acacademy-5607149ebe3d.herokuapp.com"
    let StringForList = "/list/mangas"
}

enum APIRouter {
    case get(page: Int? = 1, per: Int? = 20)
    case post
    
    var url: URL {
        switch self {
        case .get(let page, let per):
            var parameters = URLComponents(string: APIConstant.shared.URLMangaAPI + APIConstant.shared.StringForList)
            parameters?.queryItems = [
                URLQueryItem(name: "page", value: String(page!)),
                URLQueryItem(name: "per", value: String(per!))
            ]
            return (parameters?.url!)!
        case .post:
            return URL(string: APIConstant.shared.URLMangaAPI + APIConstant.shared.StringForList)!
        }
    }

    var method: String {
       switch self {
       case .get(_, _):
           return "GET"
       case .post:
           return "POST"
       }
   }

    var urlRequest: URLRequest {
        var urlRequest = URLRequest(url: self.url)
        urlRequest.httpMethod = self.method
        return urlRequest
    }
}
