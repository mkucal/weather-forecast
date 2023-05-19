//
//  WeatherApiData.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 19/05/2023.
//

import Foundation

struct WeatherApiData: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

    }

    private enum CodingKeys: String, CodingKey {
        case currentWeather = "current_weather"
        case hourlyForecastUnits = "hourly_units"
        case hourlyForecast = "hourly"
        case dailyForecastUnits = "daily_units"
        case dailyForecast = "daily"
    }
}

struct CurrentWeatherApiData: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

    }

    private enum CodingKeys: String, CodingKey {
        case temperature
        case windSpeed = "windspeed"
        case windDirection = "winddirection"
        case weatherCode = "weathercode"
        case time
    }
}

struct HourlyForecastUnitsApiData: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

    }

    private enum CodingKeys: String, CodingKey {
        case temperature = "temperature_2m"
        case relativeHumidity = "relativehumidity_2m"
        case apparentTemperature = "apparent_temperature"
        case precipitation
        case weatherCode = "weathercode"
        case surfacePressure = "surface_pressure"
        case windSpeed = "windspeed_10m"
        case windDirection = "winddirection_10m"
    }
}

struct HourlyForecastApiData: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

    }

    private enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case relativeHumidity = "relativehumidity_2m"
        case apparentTemperature = "apparent_temperature"
        case precipitation
        case weatherCode = "weathercode"
        case surfacePressure = "surface_pressure"
        case windSpeed = "windspeed_10m"
        case windDirection = "winddirection_10m"
    }
}

struct DailyForecastUnitsApiData: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

    }

    private enum CodingKeys: String, CodingKey {
        case weatherCode = "weathercode"
        case temperatureMax = "temperature_2m_max"
        case temperatureMin = "temperature_2m_min"
        case apparentTemperatureMax = "apparent_temperature_max"
        case apparentTemperatureMin = "apparent_temperature_min"
        case precipitationSum = "precipitation_sum"
    }
}

struct DailyForecastApiData: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

    }

    private enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weathercode"
        case temperatureMax = "temperature_2m_max"
        case temperatureMin = "temperature_2m_min"
        case apparentTemperatureMax = "apparent_temperature_max"
        case apparentTemperatureMin = "apparent_temperature_min"
        case precipitationSum = "precipitation_sum"
    }
}
