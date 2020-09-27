//
//  MainViewEvent.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 06/09/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import Foundation

protocol MainViewEvent {}

struct TappedAddButtonEvent: MainViewEvent {}

struct LoadViewData: MainViewEvent {}
