//
//  NetworkResponse.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 06/09/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import Foundation

// TODO: This is intented to make the network errors more clear and typesafe
// For now it does not do anything, just has a specific error

enum NetworkError: String, Error {
    case basicError = "Sorry, something went wrong :("
    case decondingError = "Sorry, server data is malformed"
    
    var localizedDescription: String {
        return self.rawValue
    }
}
