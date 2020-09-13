//
//  NetworkDisptacher.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 06/09/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import Foundation

typealias TaskExecutionCompletion<DecodeType> = (Result<DecodeType, NetworkError>) -> Void

final class NetworkDisptacher: NetworkDispatcher {
    private(set) var session: URLSession
    
    init(session: URLSession? = nil) {
        self.session = session ?? URLSession.shared
    }
    
    func execute<TaskType, DecodeType>(dataTask: TaskType, decodeType: DecodeType.Type, completion: @escaping TaskExecutionCompletion<DecodeType>) where TaskType : DataTask, DecodeType : Decodable {}
}
