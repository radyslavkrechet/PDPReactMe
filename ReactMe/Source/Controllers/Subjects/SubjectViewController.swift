//
//  PublishSubjectViewController.swift
//  ReactMe
//
//  Created by Radislav Crechet on 4/26/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import RxSwift

class SubjectViewController: UIViewController {
    @IBOutlet var firstSequenceSubscribeButton: UIButton!
    @IBOutlet var firstSequenceDisposeButton: UIButton!
    @IBOutlet var firstSequenceCurrentEventLabel: UILabel!
    @IBOutlet var firstSequencePreviousEventLabel: UILabel!
    @IBOutlet var firstSequenceOlderEventLabel: UILabel!
    @IBOutlet var secondSequenceSubscribeButton: UIButton!
    @IBOutlet var secondSequenceDisposeButton: UIButton!
    @IBOutlet var secondSequenceCurrentEventLabel: UILabel!
    @IBOutlet var secondSequencePreviousEventLabel: UILabel!
    @IBOutlet var secondSequenceOlderEventLabel: UILabel!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var completionButton: UIButton!
    @IBOutlet var echoLabel: UILabel!
    
    var subject = Subject.publish {
        didSet {
            switch subject {
            case .publish:
                observable = PublishSubject<Int>()
                title = "Publish Subject"
            case .behavior:
                observable = BehaviorSubject(value: 0)
                title = "Behavior Subject"
            case .replay:
                observable = ReplaySubject<Int>.create(bufferSize: 2)
                title = "Replay Subject"
            case .variable:
                title = "Variable"
            }
        }
    }
    
    private let bag = DisposeBag()
    
    private var event = 0
    private var observable: Observable<Int>! = nil
    private var variable = Variable(0)
    private var firstSequenceDisposable: Disposable!
    private var secondSequenceDisposable: Disposable!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if subject == .variable {
            completionButton.isEnabled = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if firstSequenceDisposeButton.isEnabled {
            firstSequenceDisposable.dispose()
        }
        
        if secondSequenceDisposeButton.isEnabled {
            secondSequenceDisposable.dispose()
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
    
    // MARK: - Actions
    
    @IBAction func subscribeFirstSequenceButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        firstSequenceDisposeButton.isEnabled = true
        echoLabel.text = "Echo:\nSubscribe First Sequence"
        
        let observable = subject == .variable ? variable.asObservable() : self.observable!
        firstSequenceDisposable = observable.subscribe(onNext: { [unowned self] in
            self.addValue(toFirstSequence: "(\($0))")
        }, onError: { [unowned self] _ in
            self.addValue(toFirstSequence: "Error")
        }, onCompleted: { [unowned self] in
            self.addValue(toFirstSequence: "Completed")
        }) { [unowned self] in
            self.addValue(toFirstSequence: "Disposed")
        }
        
        if subject == .variable {
            firstSequenceDisposable.disposed(by: bag)
        }
    }
    
    @IBAction func disposeFirstSequenceButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        firstSequenceSubscribeButton.isEnabled = true
        echoLabel.text = "Echo:\nDispose First Sequence"
        
        firstSequenceDisposable.dispose()
    }
    
    @IBAction func subscribeSecondSequenceButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        secondSequenceDisposeButton.isEnabled = true
        echoLabel.text = "Echo:\nSubscribe Second Sequence"
        
        let observable = subject == .variable ? variable.asObservable() : self.observable!
        secondSequenceDisposable = observable.subscribe(onNext: { [unowned self] in
            self.addValue(toSecondSequence: "(\($0))")
        }, onError: { [unowned self] _ in
            self.addValue(toSecondSequence: "Error")
        }, onCompleted: { [unowned self] in
            self.addValue(toSecondSequence: "Completed")
        }) { [unowned self] in
            self.addValue(toSecondSequence: "Disposed")
        }
        
        if subject == .variable {
            secondSequenceDisposable.disposed(by: bag)
        }
    }
    
    @IBAction func disposeSecondSequenceButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        secondSequenceSubscribeButton.isEnabled = true
        echoLabel.text = "Echo:\nDispose Second Sequence"
        
        secondSequenceDisposable.dispose()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        event += 1
        echoLabel.text = "Echo:\nNext \(event)"
        
        switch subject {
        case .publish:
            let subject = observable as! PublishSubject
            subject.onNext(event)
        case .behavior:
            let subject = observable as! BehaviorSubject
            subject.onNext(event)
        case .replay:
            let subject = observable as! ReplaySubject
            subject.onNext(event)
        case .variable:
            variable.value = event
        }
    }
    
    @IBAction func completionButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        nextButton.isEnabled = false
        firstSequenceSubscribeButton.isEnabled = false
        secondSequenceSubscribeButton.isEnabled = false
        echoLabel.text = "Echo:\nCompletion"
        
        switch subject {
        case .publish:
            let subject = observable as! PublishSubject
            subject.onCompleted()
        case .behavior:
            let subject = observable as! BehaviorSubject
            subject.onCompleted()
        case .replay:
            let subject = observable as! ReplaySubject
            subject.onCompleted()
        case .variable:
            break
        }
        
        if firstSequenceDisposeButton.isEnabled {
            firstSequenceDisposeButton.isEnabled = false
            
            firstSequenceDisposable.dispose()
        }
        
        if secondSequenceDisposeButton.isEnabled {
            secondSequenceDisposeButton.isEnabled = false
            
            secondSequenceDisposable.dispose()
        }
    }
}
