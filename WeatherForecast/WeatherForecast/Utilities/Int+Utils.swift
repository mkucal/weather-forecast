//
//  Int+Utils.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 21/05/2023.
//

import Foundation

extension Int {

    // TODO:

    var weatherStateIconName: String? {
        return "cloud"
    }

    var weatherStateDescription: String? {
        switch self {
        case 0:
            return NSLocalizedString("Clear sky", comment: "")
        case 1, 2, 3:
            return NSLocalizedString("Cloudy", comment: "")
        case 45, 48:
            return NSLocalizedString("Fog", comment: "")
        case 51, 53, 55:
            return NSLocalizedString("Drizzle", comment: "")
        case 56, 57:
            return NSLocalizedString("Freezing drizzle", comment: "")
        case 61, 63, 65:
            return NSLocalizedString("Rain", comment: "")
        case 66, 67:
            return NSLocalizedString("Freezing rain", comment: "")
        case 71, 73, 75:
            return NSLocalizedString("Snow fall", comment: "")
        case 77:
            return NSLocalizedString("Snow grains", comment: "")
        case 80, 81, 82:
            return NSLocalizedString("Rain showers", comment: "")
        case 85, 86:
            return NSLocalizedString("Snow showers", comment: "")
        case 95:
            return NSLocalizedString("Thunderstorm", comment: "")
        case 96, 99:
            return NSLocalizedString("Thunderstorm", comment: "")
        default:
            return nil
        }
    }
}
