//
//  MVVM_TableviewUITests.swift
//  MVVM_TableviewUITests
//
//  Created by P, Rajeswari on 07/04/21.
//

import XCTest

class MVVM_TableviewUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp(){
        super.setUp()
        continueAfterFailure = false
        app.launch()
        print(app.debugDescription)
    }
    
    func testTableviewCreation() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let myTable = app.tables.matching(identifier: "tableViewIdentifier")
        wait(for: 15)
        XCTAssertNotNil(myTable)
        
    }
    
    func testTableViewCellCreation() {
        testTableviewCreation()
        let myTable = app.tables.matching(identifier: "tableViewIdentifier")
        let cell = myTable.cells.element(matching: .cell, identifier: "listTableViewCell0")
        XCTAssertNotNil(cell)
    }
    
    func testTableCellCanbeTappable() {
        testTableViewCellCreation()
        let myTable = app.tables.matching(identifier: "tableViewIdentifier")
        let cell = myTable.cells.element(matching: .cell, identifier: "listTableViewCell0")
        cell.tap()
        XCTAssertNotNil(cell.tap(), "Cell Tapped")
        
    }
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCTestCase {
    
    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")
        
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }
        
        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
}
