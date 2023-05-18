//
//  ResponseProtocol.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 18/05/2023.
//

import Foundation

protocol ResponseProtocol {
    func validateResponse(response: URLResponse?) throws
}

extension ResponseProtocol {

    func validateResponse(response: URLResponse?) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noNetwork
        }

        do {
            try filterStatusCode(statusCode: httpResponse.statusCode)
        } catch let error as EndpointError {
            throw error
        } catch {
            throw EndpointError.serverError
        }
    }
}

extension ResponseProtocol {

    func filterStatusCode(statusCode: Int) throws {
        switch statusCode {
        case 400...600: throw EndpointError(statusCode: statusCode)
        default: break
        }
    }
}
