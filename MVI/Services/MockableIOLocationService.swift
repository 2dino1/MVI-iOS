//
//  MockableIOLocationService.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 27/09/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import Foundation

final class MockableIOLocationService: LocationService {
    // MARK: - Properties
    private let networkDispatcher: NetworkDispatcher
    
    // MARK: - Init
    init(networkDispatcher: NetworkDispatcher) {
        self.networkDispatcher = networkDispatcher
    }
    
    // MARK: - Public Method
    func fetchLocations(completion: @escaping LocationNetworkCompletion) {
        let locationDataTask: LocationDataTask = LocationDataTask(baseUrl: APIEndPoints.locations.rawValue, path: APIEndPoints.locations.endPointPath)
        
        self.networkDispatcher.execute(dataTask: locationDataTask, decodeType: LocationDataTask.Location.self) { (result) in
            switch result {
            case .success(let locations): completion(.success(locations.locationsDetails))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
