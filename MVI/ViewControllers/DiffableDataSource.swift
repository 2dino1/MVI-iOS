//
//  DiffableDataSource.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 27/09/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import UIKit

enum Section: Hashable {
    case main
}

typealias DataSource = UITableViewDiffableDataSource<Section, LocationUIModel>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, LocationUIModel>
