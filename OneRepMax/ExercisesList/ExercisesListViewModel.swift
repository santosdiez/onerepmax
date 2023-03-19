//
//  ExercisesListViewModel.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import Combine
import Foundation

struct ExerciseListItem: Identifiable {
    let id: UUID
    let name: String
    let oneRepMax: Decimal?
}

protocol ExercisesListViewModelProtocol: ObservableObject {
    var exercises: [ExerciseListItem] { get set }
}

class ExercisesListViewModel: ExercisesListViewModelProtocol {
    @Published var exercises: [ExerciseListItem] = []
    private let model: ExerciseListModelProtocol
    private var cancellable: AnyCancellable?
    
    init(model: ExerciseListModelProtocol) {
        self.model = model
        cancellable = model.exercises.sink { exercises in
            self.exercises = exercises
        }
    }
}
