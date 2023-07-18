//
//  File.swift
//  Disko
//
//  Created by Besher Al Maleh on 7/17/23.
//

import Foundation

struct File: Identifiable {
    var id: String { name }
    let name: String
    let sizeInBytes: Int
    let dateModified: Date
    let url: URL
    
    var sizeInMegaBytes: Measurement<UnitInformationStorage> {
        let sizeInBytes = Measurement(value: Double(sizeInBytes), unit: UnitInformationStorage.bytes)
        return sizeInBytes.converted(to: .megabytes)
    }
}
