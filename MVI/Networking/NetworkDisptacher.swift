//
//  NetworkDisptacher.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 06/09/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import Foundation

typealias TaskExecutionCompletion<DecodeType> = (Result<DecodeType, NetworkError>) -> Void

final class MockableIONetworkDisptacher: NetworkDispatcher {
    // MARK: - Properties
    private(set) var session: URLSession
    
    // MARK: - Init
    init(session: URLSession? = nil) {
        self.session = session ?? URLSession.shared
    }
    
    // MARK: - Public Method
    func execute<TaskType, DecodeType>(dataTask: TaskType, decodeType: DecodeType.Type, completion: @escaping TaskExecutionCompletion<DecodeType>) where TaskType : DataTask, DecodeType : Decodable {
        guard let request = dataTask.urlRequest else { return }
        
        self.session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(.failure(.basicError)) }
                return
            }
            
            do {
                let decodedResult = try JSONDecoder().decode(decodeType, from: data)
                DispatchQueue.main.async { completion(.success(decodedResult)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.decondingError)) }
            }
        }.resume()
    }
}
