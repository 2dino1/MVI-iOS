//
//  MainViewState.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 06/09/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import Foundation

protocol MainViewState {}

struct SuccessfulFetchState: MainViewState {
    let locations: [LocationUIModel]
}

struct ErrorState: MainViewState {
    let title: String
    let body: String
}
