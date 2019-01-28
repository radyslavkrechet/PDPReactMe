//
//  MapOperatorViewController.swift
//  ReactMe
//
//  Created by Radislav Crechet on 4/27/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import RxSwift

class MapOperatorViewController: UIViewController {
    @IBOutlet var currentEventLabel: UILabel!
    @IBOutlet var previousEventLabel: UILabel!
    @IBOutlet var olderEventLabel: UILabel!
    @IBOutlet var echoLabel: UILabel!

    private let subject = PublishSubject<Int>()
    private let bag = DisposeBag()
    
    private var event = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let observable = subject.map { "(\($0))" }
        
        let disposable = observable.subscribe(onNext: { [unowned self] in
            self.addValue($0)
        })
        
        disposable.disposed(by: bag)
        
    }
    
    // MARK: - Configuration
    
    private func addValue(_ value: String) {
        olderEventLabel.text = previousEventLabel.text
        previousEventLabel.text = currentEventLabel.text
        currentEventLabel.text = value
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        event += 1
        echoLabel.text = "Echo:\nNext \(event)"
        
        subject.onNext(event)
    }
}
