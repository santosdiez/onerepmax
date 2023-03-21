//
//  ExerciseDetailTests.swift
//  OneRepMaxTests
//
//  Created by Borja Santos-Díez on 19/3/23.
//

import Foundation
@testable import OneRepMax
import SnapshotTesting
import SwiftUI
import XCTest

// Commented out due to a crash in the snapshot testing library
// happening apparently linked to the usage of Swift Charts.
// See related issues:
//  - https://github.com/pointfreeco/swift-snapshot-testing/issues/522
//  - https://github.com/pointfreeco/swift-snapshot-testing/pull/627

//final class ExerciseDetailTests: XCTestCase {
//    private let traitDarkMode = UITraitCollection(userInterfaceStyle: .dark)
//
//    func testDefaultAppearance() {
//        let detailView = ExerciseDetail(
//            viewModel: ExerciseDetailViewModel(model: ExerciseDetailModelFake())
//        )
//        .environment(\.locale, .init(identifier: "en"))
//
//        let viewController = UIHostingController(rootView: detailView)
//
//        // Uncomment this line to re-generate the snapshots
//        isRecording = true
//
//        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Mini))
//        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Pro))
//        assertSnapshot(matching: viewController, as: .image(on: .iPhone13ProMax))
//        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Mini, traits: traitDarkMode))
//        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Pro, traits: traitDarkMode))
//        assertSnapshot(matching: viewController, as: .image(on: .iPhone13ProMax, traits: traitDarkMode))
//    }
//}
