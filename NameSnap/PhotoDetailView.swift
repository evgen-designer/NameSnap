//
//  PhotoDetailView.swift
//  NameSnap
//
//  Created by Eugene Evgen on 07/11/2024.
//

import SwiftUI
import MapKit

struct PhotoDetailView: View {
    let photo: NamedPhoto
    @State private var showMap = false
    
    var body: some View {
        VStack {
            Picker("View mode", selection: $showMap) {
                Text("Photo").tag(false)
                Text("Map").tag(true)
            }
            .pickerStyle(.segmented)
            .padding()
            
            if showMap {
                if let lat = photo.latitude, let lon = photo.longitude {
                    Map {
                        Marker(photo.name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ContentUnavailableView("No location data", 
                        systemImage: "location.slash",
                        description: Text("This photo doesn't have any location data associated with it.")
                    )
                }
            } else {
                if let image = UIImage(data: photo.photoData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .navigationTitle(photo.name)
    }
}

#Preview {
    NavigationStack {
        PhotoDetailView(photo: NamedPhoto(
            name: "Sample photo",
            photoData: UIImage(systemName: "photo")?.pngData() ?? Data(),
            latitude: 37.334_900,
            longitude: -122.009_020
        ))
    }
}
