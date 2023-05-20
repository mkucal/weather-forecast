//
//  Errors.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 19/05/2023.
//

import Foundation

enum GeneralError: Error {
    case general
    case emptySelf
}

enum GeocodingError: Error {
    case locationNotFound
}
