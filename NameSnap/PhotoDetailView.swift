//
//  PhotoDetailView.swift
//  NameSnap
//
//  Created by Eugene Evgen on 07/11/2024.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: NamedPhoto
    
    var body: some View {
        if let image = UIImage(data: photo.photoData) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .navigationTitle(photo.name)
        }
    }
}
