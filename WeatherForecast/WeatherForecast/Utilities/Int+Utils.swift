//
//  Int+Utils.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 21/05/2023.
//

import Foundation

extension Int {

    // TODO:

    var weatherStateData: (iconName: String?, description: String?)? {
        switch self {
        case 0:
            return ("cloud", NSLocalizedString("Clear sky", comment: ""))
        case 1, 2, 3:
            return ("cloud", NSLocalizedString("Cloudy", comment: ""))
        case 45, 48:
            return ("cloud", NSLocalizedString("Fog", comment: ""))
        case 51, 53, 55:
            return ("cloud", NSLocalizedString("Drizzle", comment: ""))
        case 56, 57:
            return ("cloud", NSLocalizedString("Freezing drizzle", comment: ""))
        case 61, 63, 65:
            return ("cloud", NSLocalizedString("Rain", comment: ""))
        case 66, 67:
            return ("cloud", NSLocalizedString("Freezing rain", comment: ""))
        case 71, 73, 75:
            return ("cloud", NSLocalizedString("Snow fall", comment: ""))
        case 77:
            return ("cloud", NSLocalizedString("Snow grains", comment: ""))
        case 80, 81, 82:
            return ("cloud", NSLocalizedString("Rain showers", comment: ""))
        case 85, 86:
            return ("cloud", NSLocalizedString("Snow showers", comment: ""))
        case 95:
            return ("cloud", NSLocalizedString("Thunderstorm", comment: ""))
        case 96, 99:
            return ("cloud", NSLocalizedString("Thunderstorm", comment: ""))
        default:
            return nil
        }
    }
}
