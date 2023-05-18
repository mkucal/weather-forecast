//
//  Request.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 18/05/2023.
//

import Foundation
import Result

class Request: RequestProtocol, ResponseProtocol {

    let query: QueryProtocol
    let session: URLSession

    init(query: QueryProtocol, session: URLSession) {
        self.query = query
        self.session = session
    }

    func resume(foundationRequest: URLRequest? = nil, completionHandler: @escaping RequestCompletionClosure) {
        let foundationRequest = foundationRequest ?? self.foundationRequest

        let dataTask = session.dataTask(with: foundationRequest) { [weak self] (data, response, _) in
            guard let self = self else {
                completionHandler(Result(error: GeneralError.emptySelf))
                return
            }

            do {
                try self.validateResponse(response: response)

                let result: Result<[Decodable], Error>
                if let decoder = self.query.decoder {
                    let parsedModel = try decoder.parseData(data: data)
                    result = Result<[Decodable], Error>(value: parsedModel)
                } else {
                    result = Result<[Decodable], Error>(value: [])
                }
                completionHandler(result)
            } catch {
                print("API error: \(error)")
                
                let result = Result<[Decodable], Error>(error: error)
                completionHandler(result)
            }
        }

        dataTask.resume()
    }
}
