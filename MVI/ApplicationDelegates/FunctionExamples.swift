//
//  FunctionExamples.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 25/10/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import Foundation

// VM --> LoginService --> Generic User --> VM --> User Defauts

struct Doctor: Decodable {}
struct Patient: Decodable {}

enum UserType: Int {
    case doctor = 0
    case patient
    case caregiven
}

struct User {
    let type: UserType = UserType(rawValue: 0)!
}

protocol LoginService {
    associatedtype ResponseType where ResponseType: Decodable
    var loginResponse: Response<ResponseType> { get }
    func executeRequest<UserType>() -> UserType
}

struct Response<T: Decodable>: Decodable {
    let response: T
}

final class NetworkDispatcherSecond {
    func executeRequest() {
        URLSession.shared.dataTask(with: URL(string: "")!) { (data, request, error) in
            guard let data = data else { return }
            
            let res = try! JSONDecoder().decode(Response<Doctor>.self, from: data)
            
        }
    }
}
