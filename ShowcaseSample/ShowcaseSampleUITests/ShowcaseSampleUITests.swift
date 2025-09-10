//
//  ShowcaseSampleUITests.swift
//  ShowcaseSampleUITests
//
//  Created by Veli Bacik on 17.04.2019.
//  Copyright © 2019 Veli Bacik. All rights reserved.
//

import XCTest

class ShowcaseSampleUITests: XCTestCase {

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        XCUIApplication().launch()
    }


    /**
     Creates a item sequence.
     
     - Parameter: first Showcase.
     
     - Throws: - TargetView not found
     
     - Returns: Complete sequence item.
     */
    func testSingleShowcase() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.buttons["UIButton Showcase"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 2).tap()
        XCUIApplication().launch()
    }
    
    
    /**
     Creates a items sequence.
     
     - Parameter: Showcase key must unique or doesn't set.
     
     - Throws: -
     
     - Returns: Complete sequence view.
     */
    func testSequenceShowcase() {
        
        let app = XCUIApplication()
        app.buttons["Sequence"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1)
        element.children(matching: .other).element(boundBy: 2).tap()
        element.children(matching: .other).element(boundBy: 1).tap()
        element.tap()
        sleep(5)
    }
    
    func testSample() {
        let app = XCUIApplication()
        app.buttons["UIButton Showcase"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1)
        element.children(matching: .other).element(boundBy: 4).tap()
        app.buttons["Left"].tap()
        element.children(matching: .other).element(boundBy: 2).tap()
        app.tabBars.buttons["History"].tap()
    }

}
