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
                Text("\(detail.oneRepMaxData.count) data points")
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
