//
//  ApiErrors.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 18/05/2023.
//

import Foundation

enum EndpointError: Error {
    case badRequest
    case unauthorized
    case deleted
    case forbidden
    case notFound
    case serverError
    case tooManyRequests

    init(statusCode: Int) {
        switch statusCode {
        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 410: self = .deleted
        case 403: self = .forbidden
        case 404: self = .notFound
        case 422: self = .badRequest
        case 429: self = .tooManyRequests
        default: self = .serverError
        }
    }
}

enum NetworkError: Error {
    case noNetwork
}

enum ParsingError: Error {
    case invalidJson
    case noData
}
