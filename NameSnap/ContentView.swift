//
//  ContentView.swift
//  NameSnap
//
//  Created by Eugene Evgen on 07/11/2024.
//

import SwiftUI
import PhotosUI
import CoreLocation

struct ContentView: View {
    @State private var photoStorage = PhotoStorage()
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingNamePrompt = false
    @State private var newPhotoData: Data?
    @State private var newPhotoName = ""
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(photoStorage.photos) { photo in
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
                .onDelete { indexSet in
                    for index in indexSet {
                        photoStorage.delete(photoStorage.photos[index])
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
        .onAppear {
            locationFetcher.start()
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
                    let location = locationFetcher.lastKnownLocation
                    let photo = NamedPhoto(
                        name: newPhotoName, 
                        photoData: photoData,
                        latitude: location?.latitude,
                        longitude: location?.longitude
                    )
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
