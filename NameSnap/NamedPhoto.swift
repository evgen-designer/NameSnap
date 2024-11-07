//
//  NamedPhoto.swift
//  NameSnap
//
//  Created by Eugene Evgen on 07/11/2024.
//

import Foundation

struct NamedPhoto: Codable, Identifiable, Comparable {
    let id: UUID
    let name: String
    let photoData: Data
    let createdAt: Date
    
    init(id: UUID = UUID(), name: String, photoData: Data, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.photoData = photoData
        self.createdAt = createdAt
    }
    
    // Comparable conformance to enable sorting
    static func < (lhs: NamedPhoto, rhs: NamedPhoto) -> Bool {
        lhs.name.lowercased() < rhs.name.lowercased()
    }
}
