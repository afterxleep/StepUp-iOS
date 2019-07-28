//
//  API.swift
//  StepUp
//
//  Created by Juan combariza on 7/26/19.
//

import Foundation

typealias SecureToken = String
typealias HttpBody = [String: String]
typealias UrlParameters = [String: String]

enum API: Parceable {
    case area(SecureToken)
    case location(SecureToken)
    case loggedInUser(SecureToken)
    case newLocalUser(SecureToken, HttpBody)
    case updateLocalUser(SecureToken, HttpBody)
    case companyValues(SecureToken)
    case contacts(SecureToken)
    case feedback(SecureToken)
    
    //MARK: - constants
    
    private static let authorizationKey             = "Authorization"
    private static let authorizationValeFormat      = "Bearer %@"
    private static let scheme                       = "https"
    private static let TestHost                     = "rankme-test.herokuapp.com"
    private static let ProdHost                     = "rankme-prod.herokuapp.com"
    private static let host                         = SystemUtils.isDebug ? TestHost : ProdHost
    
    
    //MARK: - get request
    
    func request(parameters: UrlParameters? = nil) -> URLRequest? {
        guard let url = createUrl(with: parameters) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        
        switch self {
        case .area(let token),
             .location(let token),
             .loggedInUser(let token),
             .companyValues(let token),
             .contacts(let token),
             .feedback(let token):
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = createHeader(token: token)
        case .newLocalUser(let token, let parameter):
            request.httpMethod = HTTPMethod.post.rawValue
            request.allHTTPHeaderFields = createHeader(token: token)
            request.httpBody = createBody(parameters: parameter)
        case .updateLocalUser(let token, let parameter):
            request.httpMethod = HTTPMethod.put.rawValue
            request.allHTTPHeaderFields = createHeader(token: token)
            request.httpBody = createBody(parameters: parameter)
        }
        
        return request
    }
    
    static func parser<T: Codable>(from data: Data, to: T.Type) -> T? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        
        guard let response = try? decoder.decode(T.self, from: data) else {
            return nil
        }
        
        return response
    }
    
    //MARK: - Auxiliary variables
    
    private var endPoint: String {
        switch self {
        case .area(_):
            return "/area"
        case .location(_):
            return "/location"
        case .loggedInUser(_), .newLocalUser(_), .updateLocalUser(_):
            return "/me"
        case .companyValues(_):
            return "/value"
        case .contacts(_):
            return "/people/relevant-contacts"
        case .feedback(_):
            return "/feedback"
        }
    }
    

    
    //MARK: - Auxiliary methods
    
    private func createUrl(with parameters: UrlParameters?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = API.scheme
        urlComponents.host = API.host
        urlComponents.path = endPoint
        urlComponents.queryItems = queryItems(dictionary: parameters)
        
        return urlComponents.url
    }
    
    private func queryItems(dictionary: UrlParameters?) -> [URLQueryItem]? {
        guard let dictionary = dictionary else { return nil }
        
        return dictionary.map {
            URLQueryItem(name: $0.0, value: $0.1)
        }
    }
    
    private func createHeader(token: String) -> [String: String] {
        return [API.authorizationKey: String(format: API.authorizationValeFormat, token)]
    }
    
    private func createBody(parameters: [String: String]) -> Data? {
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return nil
        }
        
        return httpBody
    }
}

protocol Parceable {
    static func parser<T: Codable>(from data: Data, to: T.Type) -> T?
}