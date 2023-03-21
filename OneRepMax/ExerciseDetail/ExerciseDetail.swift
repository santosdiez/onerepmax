//
//  ExerciseDetail.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 19/3/23.
//

import Charts
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

struct OneRepMaxPlot: View {
    var dataPoints: [OneRepMaxItem]
    @Environment(\.colorScheme) var colorScheme
    private let dataPointWidth: CGFloat = 5
    
    private var yAxisValuesRange: ClosedRange<Decimal> {
        let values = dataPoints.map { $0.value }
        
        guard let min = values.min()?.nextDown,
              let max = values.max()?.nextUp else {
            return 0...500
        }
        
        return min...max
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal) {
                Chart {
                    ForEach(dataPoints) { oneRepMax in
                        LineMark(
                            x: .value("Date", oneRepMax.date),
                            y: .value("1RM", oneRepMax.value)
                        )
                        .symbol(.circle)
                        // Couldn't find a shape style adapting both to light & dark mode
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 7)) { value in
                        AxisValueLabel(collisionResolution: .greedy) {
                            if let date = value.as(Date.self) {
                                if Calendar.current.component(.day, from: date) <= 7 {
                                    Text(date.formatted(.dateTime.day().month()))
                                        .font(.system(size: 10))
                                } else {
                                    Text(date.formatted(.dateTime.day()))
                                        .font(.system(size: 10))
                                }
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .init(
                        arrayLiteral: yAxisValuesRange.lowerBound, yAxisValuesRange.upperBound
                    )) {
                        AxisValueLabel()
                    }
                }
                .chartYScale(domain: yAxisValuesRange)
                .padding()
                .frame(width: chartWidth(for: proxy.size.width))
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    func chartWidth(for viewWidth: CGFloat) -> CGFloat {
        let dates = dataPoints.map { $0.date }
        guard let minDate = dates.min(),
              let maxDate = dates.max() else {
            return viewWidth
        }
        let days = minDate.distance(to: maxDate) / 86400
        
        let chartWidth = CGFloat(days) * dataPointWidth
        return chartWidth > viewWidth ? chartWidth : viewWidth
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
                        exerciseId: FakeData.exercises.first!.id
                    )
                )
            )
            .environment(\.locale, .init(identifier: "en"))
            .preferredColorScheme(.dark)
            
            ExerciseDetail(
                viewModel: ExerciseDetailViewModel(
                    model: ExerciseDetailModel(
                        exerciseStorage: StorageManager.exerciseStoragePreview,
                        exerciseId: FakeData.exercises.first!.id
                    )
                )
            )
            .environment(\.locale, .init(identifier: "es"))
            .preferredColorScheme(.dark)
        }
    }
}
