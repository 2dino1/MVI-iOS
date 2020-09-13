//
//  ViewController.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 02/08/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    
    // MARK: - IBOutlets/IBActions
    @IBOutlet private weak var counterLabel: UILabel!
    @IBAction private func didTapAddButton(_ sender: Any) {
        self.mainEventPublisher.send(TappedAddButtonEvent())
    }
    
    // MARK: - Properties
    private var intent: MainViewIntent!
    private var mainEventPublisher: MainEventPublisher!
    private var mainStateSubscriber: AnyCancellable?
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupMainViewIntent()
    }
}

// MARK: - Private Methods
extension MainViewController {
    private func setupMainViewIntent() {
        self.mainEventPublisher = MainEventPublisher()
        let mainStatePublisher: MainStatePublisher = MainStatePublisher()
        self.intent = MainViewIntent(mainEventPublisher: mainEventPublisher, mainStatePublisher: mainStatePublisher)
        self.createSubscriber(using: mainStatePublisher)
    }
    
    private func createSubscriber(using publisher: MainStatePublisher) {
        self.mainStateSubscriber = publisher.sink(receiveCompletion: { (error) in
            print("Error is \(error)")
        }) { [unowned self] (state) in
            if let addButtonState = state as? TappedAddButtonState {
                self.counterLabel.text = addButtonState.counterValue
            }
        }
    }
}
