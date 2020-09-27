//
//  LocationDataTask.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 27/09/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import Foundation

struct LocationDataTask: DataTask {
    private(set) var baseUrl: String
    private(set) var path: String
    private(set) var method: HttpMethod
    private(set) var queryParameters: QueryParameters?
    private(set) var headerParameters: HeaderParameters
    private(set) var bodyParameters: AnyEncodableObject?
    
    init(baseUrl: String, path: String) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = .get
        self.headerParameters = [:]
    }
}

extension LocationDataTask {
    struct Location: Decodable {
        let locationsDetails: [LocationDetails]
    }
    
    struct LocationDetails: Decodable {
        private enum CodingKeys: String, CodingKey {
            case name = "label"
            case address
            case imageURL = "image"
        }
        
        let name: String
        let address: String
        let imageURL: URL
    }
}
