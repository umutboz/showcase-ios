//
//  ShowcaseController.swift
//  Showcase
//

//

import Foundation

public protocol ShowcaseControllerDelegate: class {
    
    func ShowcaseController(_ ShowcaseController: ShowcaseController,
                                    ShowcaseWillDisappear Showcase: Showcase,
                                    forIndex index: Int)
    func ShowcaseController(_ ShowcaseController: ShowcaseController,
                                    ShowcaseDidDisappear Showcase: Showcase,
                                    forIndex index: Int)
    
}

public extension ShowcaseControllerDelegate {
    func ShowcaseController(_ ShowcaseController: ShowcaseController,
                                    ShowcaseWillDisappear Showcase: Showcase,
                                    forIndex index: Int) {
        // do nothing
    }
    
    func ShowcaseController(_ ShowcaseController: ShowcaseController,
                                    ShowcaseDidDisappear Showcase: Showcase,
                                    forIndex index: Int) {
        // do nothing
    }
}

public protocol ShowcaseControllerDataSource: class {
    func numberOfShowcases(for ShowcaseController: ShowcaseController) -> Int
    
    func ShowcaseController(_ ShowcaseController: ShowcaseController,
                                    showcaseAt index: Int) -> Showcase?
    
}

open class ShowcaseController {
    public weak var dataSource: ShowcaseControllerDataSource?
    public weak var delegate: ShowcaseControllerDelegate?
    
    public var started = false
    public var currentIndex = -1
    public weak var currentShowcase: Showcase?
    
    public init() {
        
    }
    /**
               This method zero param and returns Void.
               - returns: Void?.

               # Notes: #

               # Example #
              ```
               self.start() {
               
               }
               ```
    */
    open func start() {
        started = true
        nextShowcase()
    }
    
    /**
               This method zero param and returns Void.
               - returns: Void?.

               # Notes: #

               # Example #
              ```
               self.stop() {
               
               }
               ```
    */
    open func stop() {
        started = false
        currentIndex = -1
        currentShowcase?.completeShowcase(animated: true)
    }
    
    /**
                 This method zero param and returns Void.
                 - returns: Void?.

                 # Notes: #

                 # Example #
                ```
                 self.nextShowcase() {
                 
                 }
                 ```
    */
    open func nextShowcase() {
        if let currentShowcase = self.currentShowcase {
            currentShowcase.completeShowcase(animated: true)
            self.currentShowcase = nil
        }
        let numberOfShowcases = dataSource?.numberOfShowcases(for: self) ?? 0
        currentIndex += 1
        let showcase = dataSource?.ShowcaseController(self, showcaseAt: currentIndex)
        showcase?.delegate = self
        guard currentIndex < numberOfShowcases else {
            started = false
            currentIndex = -1
            return
        }
        currentShowcase = showcase
        showcase?.show(completion: nil)
    }
}

extension ShowcaseController: ShowcaseDelegate {
    /**
                 This method two methods param and returns Void.
                showcase: Showcase, didTapTarget: Bool
                 - returns: Void?.

                 # Notes: #

                 # Example #
                ```
                 self.showCaseWillDismiss(showcase: Showcase, didTapTarget: Bool) {
                 
                 }
                 ```
    */
    public func showCaseWillDismiss(showcase: Showcase, didTapTarget: Bool) {
        delegate?.ShowcaseController(self, ShowcaseWillDisappear: showcase, forIndex: currentIndex)
    }
    
    /**
                    This method two methods param and returns Void.
                   showcase: Showcase, didTapTarget: Bool
                    - returns: Void?.

                    # Notes: #

                    # Example #
                   ```
                    self.showCaseDidDismiss(showcase: Showcase, didTapTarget: Bool) {
                    
                    }
                    ```
       */
    public func showCaseDidDismiss(showcase: Showcase, didTapTarget: Bool) {
        delegate?.ShowcaseController(self, ShowcaseDidDisappear: showcase, forIndex: currentIndex)
        currentShowcase = nil
        if started {
            self.nextShowcase()
        }
    }
}

