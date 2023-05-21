//
//  WeatherForecastViewModel.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 21/05/2023.
//

import Foundation

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

        let now = Date()

        data = hourlyApiData.hourlyForecast?.data
            .filter {
                $0.time ?? Date() > now
            }
            .map {
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

            let time = $0.time ?? Date()
            viewModel.date = Calendar.current.isDateInToday(time) ? "Today"
            : DateFormatter.WeatherForecast.dailyForecast.string(from: time)

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
