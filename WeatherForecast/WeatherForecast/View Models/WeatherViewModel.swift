//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 20/05/2023.
//

import Foundation
import CoreLocation
import Hydra

enum WeatherDataFetchingState {
    case idle
    case running
}

struct WeatherData {
    let address: String

    var currentWeather: CurrentWeatherApiData?
    var hourlyForecastUnits: HourlyForecastUnitsApiData?
    var hourlyForecast: CombinedHourlyForecastApiData?
    var dailyForecastUnits: DailyForecastUnitsApiData?
    var dailyForecast: CombinedDailyForecastApiData?
}

class WeatherViewModel: ObservableObject {

    var address: String = ""

    @Published var fetchingState: WeatherDataFetchingState = .idle
    @Published var weatherData: WeatherData?
    @Published var fetchingError: Error?

    private let geocoder = CLGeocoder()
    private let apiWorker: WeatherForecastApiWorkerProtocol = WeatherForecastApiWorker()

    func fetchWeatherData() {
        fetchWeatherData(for: address)
    }
}

private extension WeatherViewModel {

    func calculateLocation(for address: String) -> Promise<CLLocationCoordinate2D> {
        return Promise { [weak self] resolved, rejected, _ in
            guard let self = self else {
                rejected(GeneralError.emptySelf)
                return
            }

            self.geocoder.geocodeAddressString(address) { (placemarks, error) in
                if let error = error {
                    rejected(error)
                    return
                }

                guard let location = placemarks?.first?.location?.coordinate else {
                    rejected(GeocodingError.locationNotFound)
                    return
                }

                resolved(location)
            }
        }
    }

    func fetchWeatherData(for address: String) {
        guard fetchingState != .running else {
            return
        }

        fetchingError = nil
        fetchingState = .running

        async { [weak self] _ -> WeatherData in
            guard let self = self else {
                throw GeneralError.emptySelf
            }

            let location = try Hydra.await(self.calculateLocation(for: address))
            let hourlyWeatherData = try Hydra.await(self.apiWorker.fetchHourlyWeatherForecast(for: location))
            let dailyWeatherData = try Hydra.await(self.apiWorker.fetchDailyWeatherForecast(for: location))

            let weatherData = WeatherData(address: address,
                                          currentWeather: hourlyWeatherData.currentWeather,
                                          hourlyForecastUnits: hourlyWeatherData.hourlyForecastUnits,
                                          hourlyForecast: hourlyWeatherData.hourlyForecast,
                                          dailyForecastUnits: dailyWeatherData.dailyForecastUnits,
                                          dailyForecast: dailyWeatherData.dailyForecast)
            return weatherData
        }
        .then { [weak self] weatherData in
            print("Fetching weather forecast: success")
            self?.weatherData = weatherData
        }
        .catch { [weak self] error in
            print("Fetching weather forecast: failure (\(error)")
            self?.fetchingError = error
        }
        .always(in: .main) { [weak self] in
            self?.fetchingState = .idle
        }
    }
}
