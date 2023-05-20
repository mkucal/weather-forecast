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
    var hourlyForecast: CombinedHourlyForecastApiData?
    var dailyForecastUnits: DailyForecastUnitsApiData?
    var dailyForecast: DailyForecastApiData?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        currentWeather = try container.decodeIfPresent(CurrentWeatherApiData.self, forKey: .currentWeather)
        hourlyForecastUnits = try container.decodeIfPresent(HourlyForecastUnitsApiData.self, forKey: .hourlyForecastUnits)

        if let forecast = try container.decodeIfPresent(HourlyForecastApiData.self, forKey: .hourlyForecast) {
            hourlyForecast = CombinedHourlyForecastApiData(hourlyData: forecast)
        }

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

        if let timeStr = try container.decodeIfPresent(String.self, forKey: .time) {
            time = ApiDateFormatters.hourlyForecastFormatter.date(from: timeStr)
        }
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
    var time: [Date]?
    var temperature: [Double]?
    var relativeHumidity: [Double]?
    var apparentTemperature: [Double]?
    var precipitation: [Double]?
    var weatherCode: [Int]?
    var surfacePressure: [Double]?
    var windSpeed: [Double]?
    var windDirection: [Double]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let timeStr = try container.decodeIfPresent([String].self, forKey: .time) {
            time = timeStr.compactMap {
                ApiDateFormatters.hourlyForecastFormatter.date(from: $0)
            }
        }

        temperature = try container.decodeIfPresent([Double].self, forKey: .temperature)
        relativeHumidity = try container.decodeIfPresent([Double].self, forKey: .relativeHumidity)
        apparentTemperature = try container.decodeIfPresent([Double].self, forKey: .apparentTemperature)
        precipitation = try container.decodeIfPresent([Double].self, forKey: .precipitation)
        weatherCode = try container.decodeIfPresent([Int].self, forKey: .weatherCode)
        surfacePressure = try container.decodeIfPresent([Double].self, forKey: .surfacePressure)
        windSpeed = try container.decodeIfPresent([Double].self, forKey: .windSpeed)
        windDirection = try container.decodeIfPresent([Double].self, forKey: .windDirection)
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

struct SpecifiedHourWeatherData {
    var time: Date?
    var temperature: Double?
    var relativeHumidity: Double?
    var apparentTemperature: Double?
    var precipitation: Double?
    var weatherCode: Int?
    var surfacePressure: Double?
    var windSpeed: Double?
    var windDirection: Double?
}

struct CombinedHourlyForecastApiData {
    var data: [SpecifiedHourWeatherData] = []

    init(hourlyData: HourlyForecastApiData) {
        let count = hourlyData.time?.count ?? 0

        for index in 0..<count {
            var hourDataItem = SpecifiedHourWeatherData()

            hourDataItem.time = hourlyData.time?[safe: index]
            hourDataItem.temperature = hourlyData.temperature?[safe: index]
            hourDataItem.relativeHumidity = hourlyData.relativeHumidity?[safe: index]
            hourDataItem.apparentTemperature = hourlyData.apparentTemperature?[safe: index]
            hourDataItem.precipitation = hourlyData.precipitation?[safe: index]
            hourDataItem.weatherCode = hourlyData.weatherCode?[safe: index]
            hourDataItem.surfacePressure = hourlyData.surfacePressure?[safe: index]
            hourDataItem.windSpeed = hourlyData.windSpeed?[safe: index]
            hourDataItem.windDirection = hourlyData.windDirection?[safe: index]

            self.data.append(hourDataItem)
        }
    }
}

struct DailyForecastUnitsApiData: Decodable {
    var weatherCodeUnit: String?
    var temperatureMaxUnit: String?
    var temperatureMinUnit: String?
    var apparentTemperatureMaxUnit: String?
    var apparentTemperatureMinUnit: String?
    var precipitationSumUnit: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        weatherCodeUnit = try container.decodeIfPresent(String.self, forKey: .weatherCode)
        temperatureMaxUnit = try container.decodeIfPresent(String.self, forKey: .temperatureMax)
        temperatureMinUnit = try container.decodeIfPresent(String.self, forKey: .temperatureMin)
        apparentTemperatureMaxUnit = try container.decodeIfPresent(String.self, forKey: .apparentTemperatureMax)
        apparentTemperatureMinUnit = try container.decodeIfPresent(String.self, forKey: .apparentTemperatureMin)
        precipitationSumUnit = try container.decodeIfPresent(String.self, forKey: .precipitationSum)
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
    var time: [Date]?
    var weatherCode: [Int]?
    var temperatureMax: [Double]?
    var temperatureMin: [Double]?
    var apparentTemperatureMax: [Double]?
    var apparentTemperatureMin: [Double]?
    var precipitationSum: [Double]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let timeStr = try container.decodeIfPresent([String].self, forKey: .time) {
            time = timeStr.compactMap {
                ApiDateFormatters.dailyForecastFormatter.date(from: $0)
            }
        }

        weatherCode = try container.decodeIfPresent([Int].self, forKey: .weatherCode)
        temperatureMax = try container.decodeIfPresent([Double].self, forKey: .temperatureMax)
        temperatureMin = try container.decodeIfPresent([Double].self, forKey: .temperatureMin)
        apparentTemperatureMax = try container.decodeIfPresent([Double].self, forKey: .apparentTemperatureMax)
        apparentTemperatureMin = try container.decodeIfPresent([Double].self, forKey: .apparentTemperatureMin)
        precipitationSum = try container.decodeIfPresent([Double].self, forKey: .precipitationSum)
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

private struct ApiDateFormatters {

    static let hourlyForecastFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return formatter
    }()

    static let dailyForecastFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
