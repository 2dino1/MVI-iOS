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
    private var counter: Int = 0
    
    // MARK: - Init
    init(mainEventPublisher: MainEventPublisher, mainStatePublisher: MainStatePublisher, locationService: LocationService) {
        self.mainEventPublisher = mainEventPublisher
        self.mainStatePublisher = mainStatePublisher
        self.locationService = locationService
        self.createSubscriber(using: mainEventPublisher)
    }
    
    // MARK: - Private Methods
    private func createSubscriber(using publisher: MainEventPublisher) {
        self.subscriber = publisher.sink(receiveValue: { [unowned self] (event) in
            if event is TappedAddButtonEvent {
                self.counter += 1
                self.mainStatePublisher.send(TappedAddButtonState(counterValue: "Counter value: \(self.counter)"))
            }
        })
    }
}
