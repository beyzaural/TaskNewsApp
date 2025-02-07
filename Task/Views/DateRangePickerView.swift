//
//  DateRangePickerView.swift
//  Task
//
//  Created by beyza ural on 6.02.2025.
//
import SwiftUI

struct DateRangePickerView: View {
    @Binding var selectedStartDate: Date?
    @Binding var selectedEndDate: Date?
    var onApply: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isSelectingStartDate: Bool = true
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Toggle between Start and End Date Selection
                Picker("", selection: $isSelectingStartDate) {
                    Text("Start Date").tag(true)
                    Text("End Date").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Show the appropriate DatePicker
                DatePicker(isSelectingStartDate ? "Start Date" : "End Date",
                           selection: isSelectingStartDate ? $startDate : $endDate,
                           displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(.horizontal)
                    .frame(maxHeight: 300) // Compact height
                
                Spacer()
                
                // Apply Button
                Button(action: {
                    selectedStartDate = startDate
                    selectedEndDate = endDate
                    onApply()
                    dismiss()
                }) {
                    Text("Apply")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                // Clear Filter Button
                Button(action: {
                    selectedStartDate = nil
                    selectedEndDate = nil
                    onApply()
                    dismiss()
                }) {
                    Text("Clear Filter")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Select Date Range")
            .navigationBarItems(trailing: Button("Cancel") { dismiss() })
        }
    }
}

