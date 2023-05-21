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

class WeatherViewModel: ObservableObject {

    var address: String = ""

    @Published var fetchingState: WeatherDataFetchingState = .idle
    @Published var weatherForecastViewModel: WeatherForecastViewModel?
    @Published var fetchingError: Error?

    var isFetchingRunning: Bool {
        fetchingState == .running
    }

    var fetchedWithError: Bool {
        fetchingError != nil
    }

    private let geocoder = CLGeocoder()
    private let apiWorker: WeatherForecastApiWorkerProtocol = WeatherForecastApiWorker()

    func fetchWeatherData() {
        fetchWeatherData(for: address)
    }

    func clearError() {
        fetchingError = nil
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

        async { [weak self] _ -> WeatherForecastViewModel in
            guard let self = self else {
                throw GeneralError.emptySelf
            }

            let location = try Hydra.await(self.calculateLocation(for: address))
            let hourlyWeatherData = try Hydra.await(self.apiWorker.fetchHourlyWeatherForecast(for: location))
            let dailyWeatherData = try Hydra.await(self.apiWorker.fetchDailyWeatherForecast(for: location))

            return WeatherForecastViewModel(address: address, hourlyApiData: hourlyWeatherData,
                                            dailyApiData: dailyWeatherData)
        }
        .then { [weak self] weatherForecastViewModel in
            print("Fetching weather forecast: success")
            self?.weatherForecastViewModel = weatherForecastViewModel
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
