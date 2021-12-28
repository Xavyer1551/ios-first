//
//  ApiWeather.swift
//  App Weather
//
//  Created by Fracisco Javier Martinez on 14/12/21.
//

import CoreLocation
import Foundation

public final class WeatherService : NSObject{
    private let locationManager = CLLocationManager()
    private let API_KEY = "e72e4e187f60de9d742eef648cfa461b"
    
    private var completionHandler: ((Weather) -> Void)?
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func loadWeatherData(_ completionHandler : @escaping(Weather) -> Void){
        self.completionHandler = completionHandler
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D){
        guard let urlString =
                "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)&units=metric"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url){ data, response, error in
            guard error == nil, let data = data else {return}
            
            if let response = try? JSONDecoder().decode(ApiResponse.self, from: data){
                let weather = Weather(response: response)
                self.completionHandler?(weather)
            }
        }.resume()
    }
}

extension WeatherService : CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        makeDataRequest(forCoordinates: location.coordinate)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error\(error.localizedDescription)")
    }
}

struct ApiResponse : Decodable{
    let name : String
    let main : ApiMain
    let weather : [ApiWeather]
}

struct ApiMain : Decodable{
    let temp : Double
}

struct ApiWeather : Decodable{
    let description : String
    let icoName : String
    
    enum CodingKeys : String, CodingKey{
        case description
        case icoName = "main"
    }
}
