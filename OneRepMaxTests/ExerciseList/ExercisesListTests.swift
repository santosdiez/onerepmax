//
//  ExercisesListTests.swift
//  OneRepMaxTests
//
//  Created by Borja Santos-Díez on 19/3/23.
//

import Foundation
@testable import OneRepMax
import SnapshotTesting
import SwiftUI
import XCTest

final class ExercisesListTests: XCTestCase {
    private let traitDarkMode = UITraitCollection(userInterfaceStyle: .dark)
    
    func testDefaultAppearance() {
        let list = ExercisesList(
            viewModel: ExercisesListViewModel(model: ExercisesListModelFake())
        )
        .environment(\.locale, .init(identifier: "en"))
        
        let viewController = UIHostingController(rootView: list)
        
        // Uncomment this line to re-generate the snapshots
        // isRecording = true
        
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Mini))
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Pro))
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13ProMax))
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Mini, traits: traitDarkMode))
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Pro, traits: traitDarkMode))
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13ProMax, traits: traitDarkMode))
    }
}
