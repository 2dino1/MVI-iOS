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
        urlComponents?.path = self.path
        if self.method == .get, let parameters = self.queryParameters {
            urlComponents?.queryItems = parameters.map { queryItem in URLQueryItem(name: queryItem.key, value: queryItem.value) }
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
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
    }
    
    private func setCustomHeaderParameters(forRequest request: inout URLRequest) {
        for parameter in headerParameters {
            request.setValue(parameter.value, forHTTPHeaderField: parameter.key)
        }
    }
}
