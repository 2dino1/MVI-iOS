//
//  NetworkEndPoints.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 27/09/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import Foundation

enum APIEndPoints: String {
    case locations = "http://demo2849252.mockable.io"
    
    var endPointPath: String {
        switch self {
        case .locations: return "/locations"
        }
    }
}
