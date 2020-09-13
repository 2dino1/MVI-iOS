//
//  NetworkHelpers.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 06/09/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import Foundation

typealias QueryParameters = [String: String]
typealias HeaderParameters = [String: String]

enum HttpMethod: String {
    case get = "GET"
}

struct AnyEncodableObject: Encodable {
    let value: Encodable
    
    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}

protocol NetworkDispatcher {
    var session: URLSession { get }
    func execute<TaskType, DecodeType>(dataTask: TaskType, decodeType: DecodeType.Type, completion: @escaping TaskExecutionCompletion<DecodeType>) where TaskType: DataTask, DecodeType: Decodable
}
