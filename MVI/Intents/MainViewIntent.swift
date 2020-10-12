//
//  MainViewIntent.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 06/09/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import Foundation
import Combine

typealias MainEventPublisher = PassthroughSubject<MainViewEvent, Never>
typealias MainStatePublisher = PassthroughSubject<MainViewState, Error>

final class MainViewIntent {
    // MARK: - Properties
    private var subscriber: AnyCancellable?
    private let mainEventPublisher: MainEventPublisher
    private let mainStatePublisher: MainStatePublisher
    private let locationService: LocationService
    
    // MARK: - Init
    init(mainEventPublisher: MainEventPublisher, mainStatePublisher: MainStatePublisher, locationService: LocationService) {
        self.mainEventPublisher = mainEventPublisher
        self.mainStatePublisher = mainStatePublisher
        self.locationService = locationService
        self.createSubscriber(using: mainEventPublisher)
    }
}

// MARK: - Private Methods
extension MainViewIntent {
    private func createSubscriber(using publisher: MainEventPublisher) {
        self.subscriber = publisher.sink(receiveValue: { [unowned self] (event) in
            if event is LoadLocationsDataEvent {
                self.loadLocations()
            }
        })
    }
    
    private func loadLocations() {
        self.locationService.fetchLocations { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let locations): self.mainStatePublisher.send(SuccessfulFetchState(locations: self.mapLocations(using: locations)))
            case .failure(let error): self.mainStatePublisher.send(ErrorState(title: error.title, body: error.localizedDescription))
            }
        }
    }
    
    @inline(__always) private func mapLocations(using locations: [LocationDataTask.LocationDetails]) -> [LocationUIModel] {
        return locations.map { (location) in
            return LocationUIModel(name: location.name, address: location.address, imageURL: URL(string: location.imageURL))
        }
    }
}
