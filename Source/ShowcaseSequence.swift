//
//  ShowcaseSequence.swift
//  Showcase
//

//

import Foundation

public class ShowcaseSequence {
    
    var showcaseArray : [Showcase] = []
    var key : String?
    
    
    /**
                  This method zero param and returns ShowcaseSequence.
                  -param showcase: Showcase   
                  - returns: Void?.

                  # Notes: #

                  # Example #
                 ```
                  self.target(showcase: Showcase) {
                  
                  }
         ```
     */
    public func target(_ showcase: Showcase) -> ShowcaseSequence {
        showcaseArray.append(showcase)
        return self
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
    public func start() {
        guard !getUserState(key: self.key) else {
            return
        }
        showcaseArray.first?.show(completion: increase)
    }
    /**
                 This method zero param and returns Void.
                 - returns: Void?.

                 # Notes: #

                 # Example #
                ```
                 self.increase() {
                 
                 }
        ```
    */
    func increase() -> Void {
        self.showcaseArray.removeFirst()
    }
    
    /// Set user show retry
    public func once(key : String? = nil) -> ShowcaseSequence {
        guard key != nil else {
            return self
        }
        self.key = key
        return self
    }
    
    /// Remove user state
    func removeUserState(key : String = MaterialKey._default.rawValue) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    /// Remove user state
    func getUserState(key : String?) -> Bool {
        guard key != nil else {
            return false
        }
        return UserDefaults.standard.bool(forKey: key!)
    }
    public init() { }
    
    /**
                 This method zero param and returns Void.
                 - returns: Void?.

                 # Notes: #

                 # Example #
                ```
                 self.showCaseWillDismis() {
                 
                 }
        ```
    */
    public func showCaseWillDismis() {
        guard self.showcaseArray.count > 0 else {
            //last index
            guard self.key != nil else {
                return
            }
            UserDefaults.standard.set(true, forKey: key!)
            return
        }
        showcaseArray.first?.show(completion: self.increase)
    }
    
}

