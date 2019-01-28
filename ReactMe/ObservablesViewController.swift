//
//  ViewController.swift
//  ReactMe
//
//  Created by Radislav Crechet on 4/25/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import RxSwift

class ObservablesViewController: UIViewController {
    @IBOutlet var currentEventLabel: UILabel!
    @IBOutlet var previousEventLabel: UILabel!
    @IBOutlet var olderEventLabel: UILabel!
    
    private let bag = DisposeBag()
    
    private var observable: Observable<Int>!
    private var events = [String]()
    private var isPresentedEvents = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observable = Observable.range(start: 1, count: 3)
        
        let disposable = observable.subscribe(onNext: { [unowned self] in
            self.events.append("(\($0))")
            }, onError: { [unowned self] _ in
                self.events.append("Error")
            }, onCompleted: { [unowned self] in
                self.events.append("Completed")
        }) { [unowned self] in
            self.events.append("Disposed")
        }
        
        disposable.disposed(by: bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isPresentedEvents {
            presentEvents()
            
            isPresentedEvents = true
        }
    }
    
    // MARK: - Configuration
    
    private func presentEvents() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let this = self else {
                return
            }
            
            let event = this.events.remove(at: 0)
            this.olderEventLabel.text = this.previousEventLabel.text
            this.previousEventLabel.text = this.currentEventLabel.text
            this.currentEventLabel.text = event
            
            if !this.events.isEmpty {
                this.presentEvents()
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func sectionsButtonPressed(_ sender: UIBarButtonItem) {
        navigationController!.dismiss(animated: true)
    }
}
