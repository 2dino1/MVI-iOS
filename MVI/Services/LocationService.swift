//
//  LocationService.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 27/09/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import Foundation

typealias LocationNetworkCompletion = (Result<[LocationDataTask.LocationDetails], NetworkError>) -> Void

protocol LocationService: AnyObject {
    func fetchLocations(completion: @escaping LocationNetworkCompletion)
}
