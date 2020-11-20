//
//  AddCoreDataCombine.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 20/11/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import Combine
import Foundation
import CoreData

extension Publisher {
    func sinkSaveContextPublisher(receiveCompletion: @escaping (Subscribers.Completion<Self.Failure>) -> Void, receiveValue: @escaping (Self.Output) -> Void) -> AnyCancellable {
        let subscriber = SaveContextSubscriber<Self.Output, <#Failure: Error#>>(receiveValue: receiveValue, receiveCompletion: receiveCompletion)
        self.subscribe(subscriber)
        return AnyCancellable(subscriber)
    }
}

struct SaveContextPublisher: Publisher {
    typealias Output = Void
    typealias Failure = Error
    
    private let context: NSManagedObjectContext
    init (context: NSManagedObjectContext) {
        self.context = context
    }
    
    func receive<SubscriberType>(subscriber: SubscriberType) where SubscriberType : Subscriber, Self.Failure == SubscriberType.Failure, Self.Output == SubscriberType.Input {
        let subscription = SaveContextSubscription<SaveContextSubscriber>(context: self.context)
        subscriber.receive(subscription: subscription)
    }
}

final class SaveContextSubscription<SubscriberType: Subscriber>: Subscription where SubscriberType.Input == Void, SubscriberType.Failure == Error {
    var subscriber: SubscriberType?
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func request(_ demand: Subscribers.Demand) {
        guard demand > 0 else { return }
        
        guard self.context.hasChanges else {
            self.subscriber?.receive(completion: .finished)
            return
        }
        
        do {
            try context.save()
            self.subscriber?.receive(completion: .finished)
        } catch let error {
            self.subscriber?.receive(completion: .failure(error))
        }
        
        self.cancel()
    }
    
    func cancel() {
        self.subscriber = nil
    }
}

final class SaveContextSubscriber<Input, Failure: Error>: Subscriber, Cancellable {
    typealias Input = Void
    typealias Failure = Error
    private let receiveValue: (Input) -> Void
    private let receiveCompletion: (Subscribers.Completion<Error>) -> Void
    var subscription: Subscription?
    
    init(receiveValue: @escaping (Input) -> Void, receiveCompletion: @escaping (Subscribers.Completion<Error>) -> Void) {
        self.receiveValue = receiveValue
        self.receiveCompletion = receiveCompletion
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
        self.subscription = subscription
    }
    
    func receive(_ input: Void) -> Subscribers.Demand {
        self.receiveValue(input)
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Error>) {
        self.receiveCompletion(completion)
    }
    
    func cancel() {
        self.subscription = nil
    }
    
}
