//
//  DataTask.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 06/09/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import Foundation

protocol DataTask {
    var baseUrl: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var queryParameters: QueryParameters? { get }
    var headerParameters: HeaderParameters { get }
    var bodyParameters: AnyEncodableObject? { get }
}

extension DataTask {
    var urlRequest: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        self.setHeaderParameters(forRequest: &request)
        request.httpMethod = method.rawValue
        request.httpBody = httpBody
        return request
    }
    
    private var url: URL? {
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = path
        if method == .get, let parameters = queryParameters {
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        return urlComponents?.url
    }
    
    // From iOS13 and above, a GET request cannot have body parameters. If it does, the request will instantly fail.
    private var httpBody: Data? {
        guard method == .get else { return try? JSONEncoder().encode(bodyParameters) }
        return nil
    }
}
 
// MARK: - Data Task Header Params Setup
extension DataTask {
    private func setHeaderParameters(forRequest request: inout URLRequest) {
        self.setDefaultHeaderParameters(forRequest: &request)
        self.setCustomHeaderParameters(forRequest: &request)
    }
    
    private func setDefaultHeaderParameters(forRequest request: inout URLRequest) {
//        guard let accessToken = TokenItem(keychainManager: KeychainManager.sharedInstance).getKey() else { return }
//        request.setValue(Constants.Header.Value.authorizationType + accessToken, forHTTPHeaderField: Constants.Header.Key.authorization)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    private func setCustomHeaderParameters(forRequest request: inout URLRequest) {
        for parameter in headerParameters {
            request.setValue(parameter.value, forHTTPHeaderField: parameter.key)
        }
    }
}
