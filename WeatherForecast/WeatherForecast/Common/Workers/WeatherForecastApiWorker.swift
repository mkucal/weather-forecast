//
//  WeatherForecastApiWorker.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 19/05/2023.
//

import Foundation
import Hydra

protocol WeatherForecastApiWorkerProtocol {
    func fetchHourlyWeatherForecast() -> Promise<WeatherApiData>
}

class WeatherForecastApiWorker: WeatherForecastApiWorkerProtocol {

    func fetchHourlyWeatherForecast() -> Promise<WeatherApiData> {
        let query = FetchWeatherForecastQuery()
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
