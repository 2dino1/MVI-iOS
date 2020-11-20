//
//  Combine.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 22/08/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

// TODO: Remove later
import Foundation
import Combine

struct DWDataTaskPublisher: Publisher {
    typealias Output = (data: Data, response: URLResponse)
    typealias Failure = URLError
    
    let request: URLRequest
    
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = DWDataTaskSubscription<S>(request: request)
         subscriber.receive(subscription: subscription)
    }
}

final class DWDataTaskSubscription<S: Subscriber>: Subscription where S.Failure == URLError, S.Input == (data: Data, response: URLResponse) {
    var subscriber: S?
    let request: URLRequest
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func request(_ demand: Subscribers.Demand) {
        guard demand > 0 else { return }
        
        URLSession.shared.dataTask(with: request) { (data, urlRequest, error) in
            if let error = error as? URLError {
                self.subscriber?.receive(completion: .failure(error))
            } else if let data = data, let response = urlRequest {
                _ = self.subscriber?.receive((data, response))
                self.subscriber?.receive(completion: .finished)
            }
            
            self.cancel()
            
        }.resume()
    }
    
    func cancel() {
        self.subscriber = nil
    }
}

final class DWSink<Input, Failure: Error>: Subscriber, Cancellable {
    let receiveValue: (Input) -> Void
    let receiveCompletion: (Subscribers.Completion<Failure>) -> Void
    private var subscription: Subscription?
    
    init(receiveValue: @escaping (Input) -> Void, receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void) {
        self.receiveValue = receiveValue
        self.receiveCompletion = receiveCompletion
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
        self.subscription = subscription
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        receiveValue(input)
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        receiveCompletion(completion)
    }
    
    func cancel() {
        self.subscription = nil
    }
}

extension Publisher {
    func dw_sink(receiveCompletion: @escaping (Subscribers.Completion<Self.Failure>) -> Void, receiveValue: @escaping (Self.Output) -> Void) -> AnyCancellable {
        let subscriber = DWSink(receiveValue: receiveValue, receiveCompletion: receiveCompletion)
        self.subscribe(subscriber)
        return AnyCancellable(subscriber)
    }
}
