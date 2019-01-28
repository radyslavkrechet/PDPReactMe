//
//  ComnimimgOperatorViewController.swift
//  ReactMe
//
//  Created by Radislav Crechet on 4/28/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import RxSwift

class CombimingOperatorViewController: UIViewController {
    @IBOutlet var firstSequenceCurrentEventLabel: UILabel!
    @IBOutlet var firstSequencePreviousEventLabel: UILabel!
    @IBOutlet var firstSequenceOlderEventLabel: UILabel!
    @IBOutlet var secondSequenceCurrentEventLabel: UILabel!
    @IBOutlet var secondSequencePreviousEventLabel: UILabel!
    @IBOutlet var secondSequenceOlderEventLabel: UILabel!
    @IBOutlet var operatorSequenceCurrentEventLabel: UILabel!
    @IBOutlet var operatorSequencePreviousEventLabel: UILabel!
    @IBOutlet var operatorSequenceOlderEventLabel: UILabel!
    @IBOutlet var switchButton: UIButton!
    @IBOutlet var firstCompletionButton: UIButton!
    @IBOutlet var secondCompletionButton: UIButton!
    @IBOutlet var firstNextButton: UIButton!
    @IBOutlet var secondNextButton: UIButton!
    @IBOutlet var echoLabel: UILabel!
    
    var combimingOperator = CombimingOperator.concat {
        didSet {
            switch combimingOperator {
            case .concat:
                title = "Concat"
            case .merge:
                title = "Merge"
            case .combineLatest:
                title = "Combine Latest"
            case .zip:
                title = "Zip"
            case .amb:
                title = "Amb"
            case .switchLatest:
                title = "Switch Latest"
            }
        }
    }
    
    private let firstSubject = PublishSubject<Int>()
    private let secondSubject = PublishSubject<Int>()
    private let source = PublishSubject<Observable<Int>>()
    private let bag = DisposeBag()
    
    private var sourceSubject: PublishSubject<Int>!
    private var firstSubjectEvent = 0
    private var secondSubjectEvent = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if combimingOperator != .concat {
            firstCompletionButton.isHidden = true
            secondCompletionButton.isHidden = true
        }
        
        if combimingOperator != .switchLatest {
            switchButton.isHidden = true
        }
        
        firstSubject.asObservable().subscribe(onNext: { [unowned self] in
            self.addValue(toFirstSequence: "(\($0))")
        }).disposed(by: bag)
        
        secondSubject.asObservable().subscribe(onNext: { [unowned self] in
            self.addValue(toSecondSequence: "(\($0))")
        }).disposed(by: bag)
        
        var integerObservable: Observable<Int>?
        var stringObservable: Observable<String>?
        
        switch combimingOperator {
        case .concat:
            integerObservable = firstSubject.concat(secondSubject)
        case .merge:
            integerObservable = Observable.merge(firstSubject, secondSubject)
        case .combineLatest:
            stringObservable = Observable.combineLatest(firstSubject, secondSubject) { "(\($0) \($1))" }
        case .zip:
            stringObservable = Observable.zip(firstSubject, secondSubject) { "(\($0) \($1))" }
        case .amb:
            integerObservable = firstSubject.amb(secondSubject)
        case .switchLatest:
            integerObservable = source.switchLatest()
        }

        if let observable = integerObservable {
            observable.subscribe(onNext: { [unowned self] in
                self.addValue(toOperatorSequence: "(\($0))")
            }).disposed(by: bag)
            
            if combimingOperator == .switchLatest {
                source.onNext(firstSubject)
                sourceSubject = firstSubject
            }
        } else if let observable = stringObservable {
            observable.subscribe(onNext: { [unowned self] in
                self.addValue(toOperatorSequence: $0)
            }).disposed(by: bag)
        }
    }
    
    // MARK: - Configuration
    
    private func addValue(toFirstSequence value: String) {
        firstSequenceOlderEventLabel.text = firstSequencePreviousEventLabel.text
        firstSequencePreviousEventLabel.text = firstSequenceCurrentEventLabel.text
        firstSequenceCurrentEventLabel.text = value
    }
    
    private func addValue(toSecondSequence value: String) {
        secondSequenceOlderEventLabel.text = secondSequencePreviousEventLabel.text
        secondSequencePreviousEventLabel.text = secondSequenceCurrentEventLabel.text
        secondSequenceCurrentEventLabel.text = value
    }
    
    private func addValue(toOperatorSequence value: String) {
        operatorSequenceOlderEventLabel.text = operatorSequencePreviousEventLabel.text
        operatorSequencePreviousEventLabel.text = operatorSequenceCurrentEventLabel.text
        operatorSequenceCurrentEventLabel.text = value
    }
    
    // MARK: - Actions
    
    @IBAction func switchButtonPressed(_ sender: UIButton) {
        echoLabel.text = "Echo:\nSwitch"
        
        if sourceSubject === firstSubject {
            source.onNext(secondSubject)
            sourceSubject = secondSubject
        } else {
            source.onNext(firstSubject)
            sourceSubject = firstSubject
        }
    }
    
    @IBAction func completionFirstSubjectButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        firstNextButton.isEnabled = false
        echoLabel.text = "Echo:\nFirst Subject Complited"
        
        firstSubject.onCompleted()
    }
    
    @IBAction func completionSecondSubjectButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        secondNextButton.isEnabled = false
        echoLabel.text = "Echo:\nSecond Subject Complited"
        
        secondSubject.onCompleted()
    }
    
    @IBAction func nextFirstSubjectButtonPressed(_ sender: UIButton) {
        firstSubjectEvent += 1
        echoLabel.text = "Echo:\nFirst Subject Next \(firstSubjectEvent)"
        
        firstSubject.onNext(firstSubjectEvent)
    }
    
    @IBAction func nextSecondSubjectButtonPressed(_ sender: UIButton) {
        secondSubjectEvent -= 1
        echoLabel.text = "Echo:\nSecond Subject Next \(secondSubjectEvent)"
        
        secondSubject.onNext(secondSubjectEvent)
    }
}
