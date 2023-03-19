//
//  ExercisesListViewModel.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import Combine
import Foundation

struct ExercisesListItem: Identifiable {
    let id: UUID
    let name: String
    let oneRepMax: Decimal?
}

protocol ExercisesListViewModelProtocol: ObservableObject {
    var exercises: [ExercisesListItem] { get set }
}

class ExercisesListViewModel: ExercisesListViewModelProtocol {
    @Published var exercises: [ExercisesListItem] = []
    private let model: ExercisesListModelProtocol
    private var cancellable: AnyCancellable?
    
    init(model: ExercisesListModelProtocol) {
        self.model = model
        cancellable = model.exercises.sink { exercises in
            self.exercises = exercises
        }
    }
}
