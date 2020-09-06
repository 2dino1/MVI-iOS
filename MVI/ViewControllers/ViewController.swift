//
//  ViewController.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 02/08/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import UIKit
import Combine

final class ViewController: UIViewController {
    
    @BasicExample fileprivate var x: Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.x = 5
        print("Value of the x is \(self.x)")
    }
}

@propertyWrapper
private struct BasicExample {
    private var intValue = 0
    var wrappedValue: Int {
        get { return self.intValue > 10 ? intValue : 10 }
        set { intValue = newValue }
    }
}
