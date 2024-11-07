//
//  PhotoStorage.swift
//  NameSnap
//
//  Created by Eugene Evgen on 07/11/2024.
//

import Foundation

@MainActor
class PhotoStorage {
    private let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPhotos")
    
    var photos: [NamedPhoto] = []
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            photos = try JSONDecoder().decode([NamedPhoto].self, from: data)
            photos.sort()
        } catch {
            photos = []
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(photos)
            try data.write(to: savePath, options: [.atomic])
        } catch {
            print("Unable to save photos: \(error.localizedDescription)")
        }
    }
    
    func add(_ photo: NamedPhoto) {
        photos.append(photo)
        photos.sort()
        save()
    }
}
