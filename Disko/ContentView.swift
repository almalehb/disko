//
//  ContentView.swift
//  Disko
//
//  Created by Besher Al Maleh on 7/17/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isSelectionInProgress = false
    @State private var selectedDirectory: URL?
    
    @State private var isDisplayingResults = false

    var body: some View {
        VStack (spacing: 15) {
            Text("Welcome to Disko!")
                .font(.title)
             Text("Scan a folder for large files, or scan your entire system (which can take longer.)")
                .padding()
                .multilineTextAlignment(.center)
            Button {
                // TODO
            } label: {
                Text("Scan System")
            }
            .controlSize(.large)
            .disabled(true)
            
            Button {
                isSelectionInProgress = true
            } label: {
                Text("Scan Folder...")
            }
            .controlSize(.large)
            .fileImporter(isPresented: $isSelectionInProgress, allowedContentTypes: [.directory]) { result in
                switch result {
                case .success(let url):
                    selectedDirectory = url
                    isDisplayingResults = true
                case .failure(let error): print(error.localizedDescription)
                }
            }
            
        }
        .sheet(isPresented: $isDisplayingResults) {
            ResultsView(results: readContentsOfDirectory(), isDisplayingResults: $isDisplayingResults)
                .frame(minWidth: 600, minHeight: 400)
        }
    }
    
    
    
    func readContentsOfDirectory() -> [File] {
        guard let selectedDirectory else { return [] }
        let fileManager = FileManager.default
        var results = [File]()
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: selectedDirectory, includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey, .nameKey])
            for url in fileURLs {
                let values = try url.resourceValues(forKeys: [.contentModificationDateKey, .nameKey, .fileSizeKey, .isHiddenKey])
                if let dateModified = values.contentModificationDate, let name = values.name, let size = values.fileSize {
                    if values.isHidden == true { continue }
                    let file = File(name: name, sizeInBytes: size, dateModified: dateModified, url: url)
                    results.append(file)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return results
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
