//
//  WeatherApiData.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 19/05/2023.
//

import Foundation

struct WeatherApiData: Decodable {
    var currentWeather: CurrentWeatherApiData?
    var hourlyForecastUnits: HourlyForecastUnitsApiData?
    var hourlyForecast: HourlyForecastApiData?
    var dailyForecastUnits: DailyForecastUnitsApiData?
    var dailyForecast: DailyForecastApiData?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        currentWeather = try container.decodeIfPresent(CurrentWeatherApiData.self, forKey: .currentWeather)
        hourlyForecastUnits = try container.decodeIfPresent(HourlyForecastUnitsApiData.self, forKey: .hourlyForecastUnits)
        hourlyForecast = try container.decodeIfPresent(HourlyForecastApiData.self, forKey: .hourlyForecast)
        dailyForecastUnits = try container.decodeIfPresent(DailyForecastUnitsApiData.self, forKey: .dailyForecastUnits)
        dailyForecast = try container.decodeIfPresent(DailyForecastApiData.self, forKey: .dailyForecast)
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
    var temperature: Double?
    var windSpeed: Double?
    var windDirection: Double?
    var weatherCode: Int?
    var time: Date?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        temperature = try container.decodeIfPresent(Double.self, forKey: .temperature)
        windSpeed = try container.decodeIfPresent(Double.self, forKey: .windSpeed)
        windDirection = try container.decodeIfPresent(Double.self, forKey: .windDirection)
        weatherCode = try container.decodeIfPresent(Int.self, forKey: .weatherCode)
        // TODO: time = try container.decodeIfPresent(Double.self, forKey: .time)
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
    var temperatureUnit: String?
    var relativeHumidityUnit: String?
    var apparentTemperatureUnit: String?
    var precipitationUnit: String?
    var weatherCodeUnit: String?
    var surfacePressureUnit: String?
    var windSpeedUnit: String?
    var windDirectionUnit: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        temperatureUnit = try container.decodeIfPresent(String.self, forKey: .temperature)
        relativeHumidityUnit = try container.decodeIfPresent(String.self, forKey: .relativeHumidity)
        apparentTemperatureUnit = try container.decodeIfPresent(String.self, forKey: .apparentTemperature)
        precipitationUnit = try container.decodeIfPresent(String.self, forKey: .precipitation)
        weatherCodeUnit = try container.decodeIfPresent(String.self, forKey: .weatherCode)
        surfacePressureUnit = try container.decodeIfPresent(String.self, forKey: .surfacePressure)
        windSpeedUnit = try container.decodeIfPresent(String.self, forKey: .windSpeed)
        windDirectionUnit = try container.decodeIfPresent(String.self, forKey: .windDirection)
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
