//
//  ApiProtocols.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 18/05/2023.
//

import Foundation

enum ServiceScheme: String {
    case http
    case https
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol ApiServiceProtocol {
    var scheme: ServiceScheme { get }
    var host: String { get }
    var version: String { get set }
}

protocol EndpointProtocol {
    var path: String { get }
}

protocol QueryProtocol {
    var decoder: ResponseDecoderProtocol? { get }
    var method: HttpMethod { get }
    var endpoint: EndpointProtocol { get }
    var service: ApiServiceProtocol { get }
    var parameters: Parameters { get set }
}
