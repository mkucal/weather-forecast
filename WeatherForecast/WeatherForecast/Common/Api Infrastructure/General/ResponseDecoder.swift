//
//  ResponseDecoder.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 18/05/2023.
//

import Foundation

protocol ResponseDecoderProtocol {
    func parseData(data: Data?) throws -> [Decodable]
}

struct ResponseDecoder<DecodableType>: ResponseDecoderProtocol where DecodableType: Decodable {
    
    func parseData(data: Data?) throws -> [Decodable] {
        guard let data = data else {
            throw ParsingError.noData
        }

        do {
            let result = try JSONDecoder().decode(DecodableType.self, from: data)

            if let resultArray = result as? [Decodable] {
                return resultArray
            } else {
                return [result]
            }
        } catch let error {
            let dataString = String(data: data, encoding: .utf8)
            print("Error in parsing JSON:\n\(error)\nin:\(self)\nJSON:\n\(dataString ?? "") ")

            throw ParsingError.invalidJson
        }
    }
}
