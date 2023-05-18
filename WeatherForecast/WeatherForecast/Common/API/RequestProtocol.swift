//
//  RequestProtocol.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 18/05/2023.
//

import Foundation

typealias RequestCompletionClosure = (Result<[Decodable], Error>) -> Void   // TODO: Result pod

protocol RequestProtocol {
    var query: QueryProtocol { get }
    var foundationRequest: URLRequest { get }
}

extension RequestProtocol {

    var foundationRequest: URLRequest {
        let queryItems = query.parameters.queryItems

        var components = URLComponents()
        components.scheme = query.service.scheme.rawValue
        components.host = query.service.host
        let pathElements = [query.service.version, query.endpoint.path]
        components.path = "/" + pathElements.filter { !$0.isEmpty }.joined(separator: "/")

        if !queryItems.isEmpty {
            components.queryItems = queryItems as [URLQueryItem]?
        }

        // Intentionally force unwrapping optional to get crash when problem occur
        let mutableRequest = NSMutableURLRequest(url: components.url!)
        mutableRequest.httpMethod = query.method.rawValue

        if let httpBody = query.parameters.body {
            mutableRequest.httpBody = httpBody
            mutableRequest.setValue("application/json", forHTTPHeaderField: RequestHeader.contentType.rawValue)
        }

        guard let immutableRequest = mutableRequest.copy() as? URLRequest else {
            return URLRequest(url: components.url!)
        }

        return immutableRequest
    }
}

private enum RequestHeader: String {
    case contentType = "Content-Type"
}
