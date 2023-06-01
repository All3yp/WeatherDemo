//
//  WeatherManager.swift
//  WeatherDemo
//
//  Created by Alley Pereira on 31/05/23.
//

import CoreLocation

final class WeatherManager {
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(Constants.API_KEY)&units=metric") else {
            throw ServerError.missingURL
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ServerError.responseDataError
        }
        
       let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        return decodedData
    }
}

enum ServerError: Error {
    case missingURL
    case responseDataError
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .missingURL:
            return "URL não encontrada."
        case .responseDataError:
            return "Erro ao obter dados de resposta."
        case .decodingError:
            return "Erro ao decodificar os dados."
        }
    }
}
