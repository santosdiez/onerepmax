//
//  ExerciseDetail.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 19/3/23.
//

import Foundation
import SwiftUI

struct ExerciseDetail<ViewModel: ExerciseDetailViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .tint(.primary)
        }
    }
    
    var body: some View {
        VStack {
            if let detail = viewModel.exerciseDetailItem {
                ExerciseRow(exercise: detail.exerciseListItem)
                    .fixedSize(horizontal: false, vertical: true)
                OneRepMaxPlot(dataPoints: detail.oneRepMaxData)
                Spacer()
            } else {
                ProgressView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: viewModel.fetchDetail)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
    }
}

extension OneRepMaxItem: Identifiable {
    var id: UUID { UUID() }
}

struct OneRepMaxPlot: View {
    var dataPoints: [OneRepMaxItem]
    
    var body: some View {
        List {
            ForEach(dataPoints) { oneRepMax in
                HStack {
                    Text(oneRepMax.date.formatted())
                    Spacer()
                    Text(oneRepMax.value.formatted())
                }
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - Previews

struct ExerciseDetail_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExerciseDetail(
                viewModel: ExerciseDetailViewModel(
                    model: ExerciseDetailModel(
                        exerciseStorage: StorageManager.exerciseStoragePreview,
                        exerciseId: StorageManager.exerciseStoragePreview.firstExercise!.id
                    )
                )
            )
            .environment(\.locale, .init(identifier: "en"))
            .preferredColorScheme(.dark)
            
            ExerciseDetail(
                viewModel: ExerciseDetailViewModel(
                    model: ExerciseDetailModel(
                        exerciseStorage: StorageManager.exerciseStoragePreview,
                        exerciseId: StorageManager.exerciseStoragePreview.firstExercise!.id
                    )
                )
            )
            .environment(\.locale, .init(identifier: "es"))
            .preferredColorScheme(.dark)
        }
    }
}
