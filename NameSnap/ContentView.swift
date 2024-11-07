//
//  ContentView.swift
//  NameSnap
//
//  Created by Eugene Evgen on 07/11/2024.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var photoStorage = PhotoStorage()
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingNamePrompt = false
    @State private var newPhotoData: Data?
    @State private var newPhotoName = ""
    
    var body: some View {
        NavigationStack {
            List(photoStorage.photos) { photo in
                NavigationLink(destination: PhotoDetailView(photo: photo)) {
                    HStack {
                        if let image = UIImage(data: photo.photoData) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 44, height: 44)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        Text(photo.name)
                    }
                }
            }
            .navigationTitle("NameSnap")
            .toolbar {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Image(systemName: "plus")
                }
            }
        }
        .onChange(of: selectedItem) {
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                    newPhotoData = data
                    showingNamePrompt = true
                }
                selectedItem = nil
            }
        }
        .alert("Name this photo", isPresented: $showingNamePrompt) {
            TextField("Name", text: $newPhotoName)
            
            Button("Save") {
                if let photoData = newPhotoData {
                    let photo = NamedPhoto(name: newPhotoName, photoData: photoData)
                    photoStorage.add(photo)
                    newPhotoName = ""
                    newPhotoData = nil
                }
            }
            
            Button("Cancel", role: .cancel) {
                newPhotoName = ""
                newPhotoData = nil
            }
        }
    }
}

#Preview {
    ContentView()
}
