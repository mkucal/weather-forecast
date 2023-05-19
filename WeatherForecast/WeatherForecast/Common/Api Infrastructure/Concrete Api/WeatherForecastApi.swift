//
//  WeatherForecastApi.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 19/05/2023.
//

import Foundation

private enum ForecastAttributes: String {
    case temperature = "temperature_2m"
    case apparentTemperature = "apparent_temperature"
    case relativeHumidity = "relativehumidity_2m"
    case precipitation = "precipitation"
    case weatherCode = "weathercode"
    case surfacePressure = "surface_pressure"
    case windSpeed = "windspeed_10m"
    case windDirection = "winddirection_10m"
}

private struct ParameterKeyPath {
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let hourly = "hourly"
    static let currentWeather = "current_weather"
    static let forecastDays = "forecast_days"
    static let timeZone = "timezone"
}

struct WeatherForecastService: ApiServiceProtocol {
    let scheme: ServiceScheme = .https
    let host: String = "api.open-meteo.com"
    var version: String = "v1"
}

struct Forecast: EndpointProtocol {
    let path: String = "forecast"
}

struct FetchHourlyForecastQuery: QueryProtocol {
    var decoder: ResponseDecoderProtocol? = ResponseDecoder<WeatherApiData>()
    var method: HttpMethod = .get
    var endpoint: EndpointProtocol = Forecast()
    var service: ApiServiceProtocol = WeatherForecastService()
    var parameters: Parameters = Parameters(encoding: .url)

    init() {
        parameters[ParameterKeyPath.latitude] = String(describing: 52.41)
        parameters[ParameterKeyPath.longitude] = String(describing: 16.93)

        let forecastAttributes: [ForecastAttributes] = [.temperature, .apparentTemperature,
                                                        .relativeHumidity, .precipitation,
                                                        .weatherCode, .surfacePressure,
                                                        .windSpeed, .windDirection]
        parameters[ParameterKeyPath.hourly] = forecastAttributes.map { $0.rawValue }.joined(separator: ",")
        parameters[ParameterKeyPath.currentWeather] = String(describing: true)
        parameters[ParameterKeyPath.forecastDays] = String(describing: 2)
        parameters[ParameterKeyPath.timeZone] = "Europe/Warsaw"
    }
}
