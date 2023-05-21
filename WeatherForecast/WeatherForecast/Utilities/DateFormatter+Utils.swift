//
//  DateFormatter+Utils.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 20/05/2023.
//

import Foundation

extension DateFormatter {

    struct Api {
        static let hourlyForecast: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
            return formatter
        }()

        static let dailyForecast: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    }

    struct WeatherForecast {
        static let hourlyForecast: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()

        static let dailyForecast: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d"
            return formatter
        }()
    }
}
