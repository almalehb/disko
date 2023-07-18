//
//  ResultsView.swift
//  Disko
//
//  Created by Besher Al Maleh on 7/17/23.
//

import SwiftUI

struct ResultsView: View {
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    let measurementFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        return formatter
    }()
    
    @State var results: [File] = []
    @Binding var isDisplayingResults: Bool
    
    @State private var sortOrder = [KeyPathComparator(\File.sizeInBytes, order: .reverse)]
    @State private var selection: File.ID?

    var body: some View {
        VStack {
            Button {
                isDisplayingResults = false 
            } label: {
                Text("Dismiss")
            }
            .padding()
            Table(selection: $selection, sortOrder: $sortOrder) {
                TableColumn("Name", value: \.name)
                    .width(min: 100, max: 350)
                TableColumn("Size", value: \.sizeInBytes) { file in
                    Text(measurementFormatter.string(from: file.sizeInMegaBytes))
                }
                .width(min: 80, max: 120)
                TableColumn("Date", value: \.dateModified) { file in
                    return Text(dateFormatter.string(from: file.dateModified))
                }
                .width(min: 150, max: 180)
                TableColumn("Delete") { file in
                    Button {
                        print("deleting at url: \(file.url)")
                        try? FileManager.default.trashItem(at: file.url, resultingItemURL: nil)
                        withAnimation {
                            results.removeAll { displayedFile in
                                displayedFile.id == file.id
                            }
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(Color.red)
                }
            } rows: {
                ForEach(results) { file in
                    TableRow(file)
                }
            }
            .onChange(of: sortOrder) { newOrder in
                results.sort(using: newOrder)
            }
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(isDisplayingResults: .constant(false))
    }
}

