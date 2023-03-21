//
//  ExerciseDetailViewModel.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 19/3/23.
//

import Combine
import Foundation

protocol ExerciseDetailViewModelProtocol: ObservableObject {
    var exerciseDetailItem: ExerciseDetailItem? { get }

    func fetchDetail()
}

struct OneRepMaxItem: Identifiable {
    let id: UUID
    let date: Date
    let value: Decimal
}

struct ExerciseDetailItem {
    let exerciseListItem: ExercisesListItem
    let oneRepMaxData: [OneRepMaxItem]
}

class ExerciseDetailViewModel: ExerciseDetailViewModelProtocol {
    @Published var exerciseDetailItem: ExerciseDetailItem?
    private let model: ExerciseDetailModelProtocol
    private var cancellable: AnyCancellable?

    init(model: ExerciseDetailModelProtocol) {
        self.model = model
        cancellable = model.detail.sink { detail in
            self.exerciseDetailItem = detail
        }
    }

    func fetchDetail() {
        model.fetchExercise()
    }
}
