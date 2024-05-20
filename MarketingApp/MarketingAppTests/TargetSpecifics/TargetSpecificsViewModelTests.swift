//
//  TargetSpecificsViewModelTests.swift
//  MarketingAppTests
//
//  Created by George Stratulat on 20.05.2024.
//

import XCTest
import Combine

final class TargetSpecificsViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []
    
    func testLoadDataSuccess() {
        // given
        let viewModel = TargetSpecificsViewModel(targetSpecificDA: TargetSpecificsDataAccessorMock())
        let expectation = XCTestExpectation(description: "Waiting for data to be populated")
        
        viewModel.$targetSpecifics.sink { _ in
        } receiveValue: { output in
            if output.count > 0 {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        // when
        viewModel.loadData()
        wait(for: [expectation], timeout: 3)
        
        // I expect
        XCTAssertEqual(viewModel.targetSpecifics.count, 2)
    }
    
    func testLoadDataError() {
        // given
        let dataAccessor = TargetSpecificsDataAccessorMock(shouldError: true)
        let viewModel = TargetSpecificsViewModel(targetSpecificDA: dataAccessor)
        let expectation = XCTestExpectation(description: "Waiting for data to be populated")
        
        viewModel.$error.sink { _ in
        } receiveValue: { output in
            if output != nil {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        // when
        viewModel.loadData()
        wait(for: [expectation], timeout: 3)
        
        // I expect
        XCTAssertEqual(viewModel.targetSpecifics.count, 0)
        XCTAssertNotNil(viewModel.error)
    }
    
    func testShouldGenerateProviderForSelectedTargets() throws {
        // given
        let targetingSpecifics = [TargetingSpecifics(id: 1, name: "Location", providers: [ProviderPreview(id: 1, name: "Facebook"), ProviderPreview(id: 2, name: "Twitter")]),
                                  TargetingSpecifics(id: 2, name: "Sex", providers: [ProviderPreview(id: 1, name: "Facebook"), ProviderPreview(id: 2, name: "Instagram")])]
        let dataAccessor = TargetSpecificsDataAccessorMock(targetingSpecifics: targetingSpecifics)
        let viewModel = TargetSpecificsViewModel(targetSpecificDA: dataAccessor)
        
        let expectation = XCTestExpectation(description: "Waiting for publisher to emit")
        // Wait for the publisher to emit its value
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(viewModel.targetSpecifics.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        
        // when
        viewModel.selectTarget(id: 1)
        viewModel.selectTarget(id: 2)
        
        // I expect
        let providers = viewModel.providersForTargetSpecifics()
        XCTAssertEqual(providers, [ProviderPreview(id: 1, name: "Facebook")])
    }
}
