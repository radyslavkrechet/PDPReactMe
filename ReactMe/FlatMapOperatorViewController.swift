//
//  FlatMapOperatorViewController.swift
//  ReactMe
//
//  Created by Radislav Crechet on 4/27/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import RxSwift

class FlatMapOperatorViewController: UIViewController {
    @IBOutlet var firstSequenceCurrentEventLabel: UILabel!
    @IBOutlet var firstSequencePreviousEventLabel: UILabel!
    @IBOutlet var firstSequenceOlderEventLabel: UILabel!
    @IBOutlet var secondSequenceCurrentEventLabel: UILabel!
    @IBOutlet var secondSequencePreviousEventLabel: UILabel!
    @IBOutlet var secondSequenceOlderEventLabel: UILabel!
    @IBOutlet var mapSequenceCurrentEventLabel: UILabel!
    @IBOutlet var mapSequencePreviousEventLabel: UILabel!
    @IBOutlet var mapSequenceOlderEventLabel: UILabel!
    @IBOutlet var echoLabel: UILabel!

    let firstVariable = Variable(1)
    let secondVariable = Variable(-1)
    let subject = PublishSubject<Variable<Int>>()
    private let bag = DisposeBag()
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstVariable.asObservable().subscribe(onNext: { [unowned self] in
            self.addValue(toFirstSequence: $0)
        }).disposed(by: bag)
        
        secondVariable.asObservable().subscribe(onNext: { [unowned self] in
            self.addValue(toSecondSequence: $0)
        }).disposed(by: bag)
        
        let observable = subject.flatMap { $0.asObservable() }
        
        let disposable = observable.subscribe(onNext: { [unowned self] in
            self.addValue(toMapSequence: $0)
        })
        
        disposable.disposed(by: bag)
        
        subject.onNext(firstVariable)
        subject.onNext(secondVariable)
    }
    
    // MARK: - Configuration
    
    private func addValue(toFirstSequence value: Int) {
        firstSequenceOlderEventLabel.text = firstSequencePreviousEventLabel.text
        firstSequencePreviousEventLabel.text = firstSequenceCurrentEventLabel.text
        firstSequenceCurrentEventLabel.text = "(\(value))"
    }
    
    private func addValue(toSecondSequence value: Int) {
        secondSequenceOlderEventLabel.text = secondSequencePreviousEventLabel.text
        secondSequencePreviousEventLabel.text = secondSequenceCurrentEventLabel.text
        secondSequenceCurrentEventLabel.text = "(\(value))"
    }
    
    private func addValue(toMapSequence value: Int) {
        mapSequenceOlderEventLabel.text = mapSequencePreviousEventLabel.text
        mapSequencePreviousEventLabel.text = mapSequenceCurrentEventLabel.text
        mapSequenceCurrentEventLabel.text = "(\(value))"
    }
    
    // MARK: - Actions
    
    @IBAction func firstStepperValueChanged(_ sender: UIStepper) {
        echoLabel.text = "Echo:\nFirst Stepper Value Changed"
        
        firstVariable.value = Int(sender.value)
    }
    
    @IBAction func secondStepperValueChanged(_ sender: UIStepper) {
        echoLabel.text = "Echo:\nSecond Stepper Value Changed"
        
        secondVariable.value = Int(sender.value)
    }
}
