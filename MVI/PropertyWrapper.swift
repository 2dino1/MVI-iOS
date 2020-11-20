//
//  PropertyWrapper.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 18/10/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import Foundation

extension String: Error {}

final class TestRethrowsExample {
    func testing() {
        let example = RethrowsExample()
        
        // throws example
        do {
            try example.map(transform: throwingErrors)
        } catch let error {
            print("Whoops there error is \(error)!")
        }
        
        // non throwing example
        example.map(transform: notThrowingErrors)
    }
    
    private func throwingErrors(param: String) throws {
        throw param
    }
    
    private func notThrowingErrors(param: String) {
        print("Not thowing errors \(param)")
    }
}

final class RethrowsExample {
    
    func map(transform: (String) throws -> Void) rethrows {
        // do something with your value
    }
}

final class Magic {
    @Observer(wrappedValue: nil) var updateUI: String?
    
    func doMagic() {
        self.updateUI = "Vlad"
        self.updateUI = "Dino"
    }
    
    func doDo() {
        
    }
}

@propertyWrapper
final class Observer<T> {
    typealias Listener = (T) -> Void
    
    // MARK: - Properties
    private var listener: Listener?
    private var value: T?
    
    var wrappedValue: T? {
        set {
            self.value = newValue
            guard let v = self.value else { return }
            self.listener?(v)
        }
        
        get { return value }
    }
    
    // MARK: - Init
    init(wrappedValue: T?) {
        self.value = wrappedValue
    }
    
    // MARK: - Public Methods
    func bind(listener: @escaping Listener) {
        self.listener = listener
    }
    
    func unbind() {
        self.listener = nil
    }
}

