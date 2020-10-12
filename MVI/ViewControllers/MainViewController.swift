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
    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    private var dataSource: DataSource!
    private var intent: MainViewIntent!
    private var mainEventPublisher: MainEventPublisher!
    private var mainStateSubscriber: AnyCancellable?
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupMainViewIntent()
        self.mainEventPublisher.send(LoadLocationsDataEvent())
    }
}

// MARK: - Table View Data Source
extension MainViewController {
    private func setupTableView() {
        self.createDataSource()
        self.tableView.dataSource = self.dataSource
    }
    
    private func createDataSource() {
        self.dataSource = DataSource(tableView: self.tableView) { (tableView, indexPath, model) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) 
            cell.textLabel?.text = model.name
            cell.detailTextLabel?.text = model.address
            
            return cell
        }
    }
    
    private func updateDataSource(using elements: [LocationUIModel], animated: Bool = true) {
        var snapshot: Snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(elements)
        
        self.dataSource.apply(snapshot)
    }
}

// MARK: - Table View Delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = self.dataSource.itemIdentifier(for: indexPath) else { return }
        print("Identifier")
    }
}

// MARK: - Private Methods
extension MainViewController {
    private func setupMainViewIntent() {
        self.mainEventPublisher = MainEventPublisher()
        let mainStatePublisher: MainStatePublisher = MainStatePublisher()
        self.intent = MainViewIntent(mainEventPublisher: mainEventPublisher, mainStatePublisher: mainStatePublisher, locationService: self.setupIntentDependencies())
        self.createSubscriber(using: mainStatePublisher)
    }
    
    // TOOD: Maybe inject them from outside when this will grow ??
    private func setupIntentDependencies() -> LocationService {
        let networkDispatcher: NetworkDispatcher = MockableIONetworkDisptacher(session: URLSession.shared)
        return MockableIOLocationService(networkDispatcher: networkDispatcher)
    }
    
    private func createSubscriber(using publisher: MainStatePublisher) {
        self.mainStateSubscriber = publisher.sink(receiveCompletion: { (error) in
            print("Error is \(error)")
        }) { [unowned self] (state) in
            self.handleStates(state)
        }
    }
    
    private func handleStates(_ state: MainViewState) {
        if let successfulFetchState = state as? SuccessfulFetchState {
            self.updateDataSource(using: successfulFetchState.locations)
        }
        
        if let _ = state as? ErrorState {
            // TODO: Pop up an Alert View
        }
    }
}
