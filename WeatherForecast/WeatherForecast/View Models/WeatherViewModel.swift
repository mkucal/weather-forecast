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

struct WeatherForecastViewModel {
    let address: String

    var currentWeather: CurrentWeatherViewModel?
    var hourlyForecast: HourlyForecastViewModel?
    var dailyForecast: DailyForecastViewModel?

    init(address: String, hourlyApiData: WeatherApiData?, dailyApiData: WeatherApiData?) {
        self.address = address

        currentWeather = CurrentWeatherViewModel(hourlyApiData: hourlyApiData)
        hourlyForecast = HourlyForecastViewModel(hourlyApiData: hourlyApiData)
        dailyForecast = DailyForecastViewModel(dailyApiData: dailyApiData)
    }
}

struct CurrentWeatherViewModel {
    var temperature: String?
    var weatherStateIconName: String?
    var weatherStateDesc: String?

    init?(hourlyApiData: WeatherApiData?) {
        guard let hourlyApiData = hourlyApiData else {
            return nil
        }

        let tempValue = String(describing: hourlyApiData.currentWeather?.temperature ?? 0.0)
        let tempUnit = hourlyApiData.hourlyForecastUnits?.temperatureUnit ?? ""

        temperature = tempValue + tempUnit

        guard let weatherState = hourlyApiData.currentWeather?.weatherCode?.weatherStateData else {
            return
        }
        weatherStateIconName = weatherState.iconName
        weatherStateDesc = weatherState.description
    }
}

struct SpecifiedHourForecastViewModel {
    var time: String?
    var temperature: String?
    var weatherStateIconName: String?
}

struct HourlyForecastViewModel {
    var data: [SpecifiedHourForecastViewModel] = []

    init?(hourlyApiData: WeatherApiData?) {
        guard let hourlyApiData = hourlyApiData else {
            return nil
        }

        data = hourlyApiData.hourlyForecast?.data.map {
            var viewModel = SpecifiedHourForecastViewModel()
            viewModel.time = DateFormatter.WeatherForecast.hourlyForecast.string(from: $0.time ?? Date())

            let tempValue = String(describing: $0.temperature ?? 0.0)
            let tempUnit = hourlyApiData.hourlyForecastUnits?.temperatureUnit ?? ""

            viewModel.temperature = tempValue + tempUnit
            viewModel.weatherStateIconName = $0.weatherCode?.weatherStateData?.iconName
            return viewModel
        } ?? []
    }
}

struct SpecifiedDayForecastViewModel {
    var date: String?
    var temperatureMin: String?
    var temperatureMax: String?
    var weatherStateIconName: String?
}

struct DailyForecastViewModel {
    var data: [SpecifiedDayForecastViewModel] = []

    init?(dailyApiData: WeatherApiData?) {
        guard let dailyApiData = dailyApiData else {
            return nil
        }

        data = dailyApiData.dailyForecast?.data.map {
            var viewModel = SpecifiedDayForecastViewModel()
            viewModel.date = DateFormatter.WeatherForecast.dailyForecast.string(from: $0.time ?? Date())

            var tempValue = String(describing: $0.temperatureMin ?? 0.0)
            var tempUnit = dailyApiData.dailyForecastUnits?.temperatureMinUnit ?? ""
            viewModel.temperatureMin = tempValue + tempUnit

            tempValue = String(describing: $0.temperatureMax ?? 0.0)
            tempUnit = dailyApiData.dailyForecastUnits?.temperatureMaxUnit ?? ""
            viewModel.temperatureMax = tempValue + tempUnit
            viewModel.weatherStateIconName = $0.weatherCode?.weatherStateData?.iconName
            return viewModel
        } ?? []
    }
}
