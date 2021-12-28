//
//  Weather.swift
//  App Weather
//
//  Created by Fracisco Javier Martinez on 14/12/21.
//

import Foundation

public struct Weather{
    let city : String
    let temperature : String
    let description : String
    let iconName : String
    
    init(response : ApiResponse){
        city = response.name
        temperature = "\(Int(response.main.temp))"
        description = response.weather.first?.description ?? ""
        iconName = response.weather.first?.icoName ?? ""	
    }
}
