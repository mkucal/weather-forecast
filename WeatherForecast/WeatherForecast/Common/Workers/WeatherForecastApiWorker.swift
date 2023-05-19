//
//  WeatherForecastApiWorker.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 19/05/2023.
//

import Foundation
import CoreLocation
import Hydra

protocol WeatherForecastApiWorkerProtocol {
    func fetchHourlyWeatherForecast(for location: CLLocationCoordinate2D) -> Promise<WeatherApiData>
}

class WeatherForecastApiWorker: WeatherForecastApiWorkerProtocol {

    func fetchHourlyWeatherForecast(for location: CLLocationCoordinate2D) -> Promise<WeatherApiData> {
        let hourlyAttributes: [WeatherForecastAttributes] = [.temperature, .apparentTemperature,
                                                             .relativeHumidity, .precipitation,
                                                             .weatherCode, .surfacePressure,
                                                             .windSpeed, .windDirection]
        let queryParams = FetchWeatherForecastParams(location: location, fetchCurrentWeather: true,
                                                     forecastDaysNumber: 2, timeZone: TimeZone.current,
                                                     hourlyForecastAttributes: hourlyAttributes)

        let query = FetchWeatherForecastQuery(params: queryParams)
        let request = Request(query: query, session: URLSession.shared)

        return Promise { resolved, rejected, _ in
            request.resume { result in
                switch result {
                case .success(let weatherData):
                    guard let weatherData = weatherData.first as? WeatherApiData else {
                        rejected(ParsingError.noData)
                        return
                    }
                    resolved(weatherData)
                case .failure(let error):
                    rejected(error)
                }
            }
        }
    }

    func fetchDailyWeatherForecast() {

    }
}
