//
//  WeatherForecastApi.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 19/05/2023.
//

import Foundation
import CoreLocation

struct WeatherForecastService: ApiServiceProtocol {
    let scheme: ServiceScheme = .https
    let host: String = "api.open-meteo.com"
    var version: String = "v1"
}

struct WeatherForecastEndpoint: EndpointProtocol {
    let path: String = "forecast"
}

enum WeatherForecastAttributes: String {
    case temperature = "temperature_2m"
    case temperatureMax = "temperature_2m_max"
    case temperatureMin = "temperature_2m_min"
    case apparentTemperature = "apparent_temperature"
    case apparentTemperatureMax = "apparent_temperature_max"
    case apparentTemperatureMin = "apparent_temperature_min"
    case relativeHumidity = "relativehumidity_2m"
    case precipitation = "precipitation"
    case precipitationSum = "precipitation_sum"
    case weatherCode = "weathercode"
    case surfacePressure = "surface_pressure"
    case windSpeed = "windspeed_10m"
    case windDirection = "winddirection_10m"
}

struct FetchWeatherForecastParams {
    let location: CLLocationCoordinate2D
    let forecastDaysNumber: Int
    let timeZone: TimeZone
    var fetchCurrentWeather: Bool?
    var hourlyForecastAttributes: [WeatherForecastAttributes]?
    var dailyForecastAttributes: [WeatherForecastAttributes]?
}

private struct ParameterKeyPath {
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let hourlyForecast = "hourly"
    static let dailyForecast = "daily"
    static let currentWeather = "current_weather"
    static let forecastDaysNumber = "forecast_days"
    static let timeZone = "timezone"
}

struct FetchWeatherForecastQuery: QueryProtocol {
    var decoder: ResponseDecoderProtocol? = ResponseDecoder<WeatherApiData>()
    var method: HttpMethod = .get
    var endpoint: EndpointProtocol = WeatherForecastEndpoint()
    var service: ApiServiceProtocol = WeatherForecastService()
    var parameters: Parameters = Parameters(encoding: .url)

    init(params: FetchWeatherForecastParams) {
        parameters[ParameterKeyPath.latitude] = String(describing: params.location.latitude)
        parameters[ParameterKeyPath.longitude] = String(describing: params.location.longitude)

        parameters[ParameterKeyPath.forecastDaysNumber] = String(describing: params.forecastDaysNumber)
        parameters[ParameterKeyPath.timeZone] = params.timeZone.identifier

        if let fetchCurrentWeather = params.fetchCurrentWeather {
            parameters[ParameterKeyPath.currentWeather] = String(describing: fetchCurrentWeather)
        }

        if let hourlyAttributes = params.hourlyForecastAttributes {
            parameters[ParameterKeyPath.hourlyForecast] = hourlyAttributes.map { $0.rawValue }.joined(separator: ",")
        }

        if let dailyAttributes = params.dailyForecastAttributes {
            parameters[ParameterKeyPath.dailyForecast] = dailyAttributes.map { $0.rawValue }.joined(separator: ",")
        }
    }
}
