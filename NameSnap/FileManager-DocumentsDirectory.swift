//
//  FileManager-DocumentsDirectory.swift
//  NameSnap
//
//  Created by Eugene Evgen on 07/11/2024.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
