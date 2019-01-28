//
//  FiltringOperatorViewController.swift
//  ReactMe
//
//  Created by Radislav Crechet on 4/27/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import RxSwift

class FiltringOperatorViewController: UIViewController {
    @IBOutlet var currentEventLabel: UILabel!
    @IBOutlet var previousEventLabel: UILabel!
    @IBOutlet var olderEventLabel: UILabel!
    @IBOutlet var triggerView: UIView!
    @IBOutlet var triggerLabel: UILabel!
    @IBOutlet var echoLabel: UILabel!
    
    var filtringOperator = FiltringOperator.ignoreElements {
        didSet {
            switch filtringOperator {
            case .ignoreElements:
                title = "Ignore Elements"
            case .elementAt:
                title = "Element At"
            case .filter:
                title = "Filter"
            case .skip:
                title = "Skip"
            case .skipWhile:
                title = "Skip While"
            case .skipUntil:
                title = "Skip Until"
            case .take:
                title = "Take"
            case .takeWhile:
                title = "Take While"
            case .takeUntil:
                title = "Take Until"
            }
        }
    }
    
    private let subject = PublishSubject<Int>()
    private let trigger = PublishSubject<Int>()
    private let bag = DisposeBag()
    
    private var event = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if filtringOperator != .skipUntil && filtringOperator != .takeUntil {
            triggerView.isHidden = true
        }
        
        var observable: Observable<Int>! = nil
        
        switch filtringOperator {
        case .ignoreElements:
            observable = nil
        case .elementAt:
            observable = subject.elementAt(0)
        case .filter:
            observable = subject.filter { $0 % 2 == 0 }
        case .skip:
            observable = subject.skip(1)
        case .skipWhile:
            observable = subject.skipWhile { $0 % 2 != 0 }
        case .skipUntil:
            observable = subject.skipUntil(trigger)
        case .take:
            observable = subject.take(1)
        case .takeWhile:
            observable = subject.takeWhile { $0 % 2 != 0 }
        case .takeUntil:
            observable = subject.takeUntil(trigger)
        }

        guard let _ = observable else {
            return
        }

        let disposable = observable.subscribe(onNext: { [unowned self] in
            self.addValue("(\($0))")
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
    
    @IBAction func pullButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        triggerLabel.text = "Event"
        echoLabel.text = "Echo:\nPull The Trigger"
        
        trigger.onNext(0)
        
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        event += 1
        echoLabel.text = "Echo:\nNext \(event)"
        
        subject.onNext(event)
    }
}
