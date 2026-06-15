//
//  ContentView.swift
//  BucketList
//
//  Created by Merve Akçakaya on 9.06.2026.
//

import SwiftUI
import MapKit
/*
 MapReader - proxy.convert = ekrana dokununca konumun enlem ve boylamını vermesini sağlar.
 Haritada işaretlenen yerleri göstermek için Marker kullanıyoruz fakat bunu ozellestirmek icin Marker yerine Annotation yazıyoruz.
 */
 
struct ContentView: View {
  
    let startPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    )
    @State private var locations = [Location]()
    @State private var selectedPlace : Location?
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition)
            {
                ForEach(locations){location in
                    Annotation(location.name, coordinate: location.coordinate){
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundStyle(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(.circle)
                            .simultaneousGesture(
                                LongPressGesture(minimumDuration: 0.5)
                                    .onEnded{_ in
                                        selectedPlace = location
                                    }
                            )
                    }
                }
            }
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local){
                    let newLocation = Location(
                        id: UUID(),
                        name: "",
                        description: "New Location",
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude
                    )
                    locations.append(newLocation)
                }
            }
            //item nil olmadıgı surece sheet acık kalıyor.
            .sheet(item: $selectedPlace){place in
                //burada editView içindeki location değişkeninin içi doluyor.
                EditView(location: place){newLocation in
                    if let index = locations.firstIndex(of: place){
                        locations[index] = newLocation
                    }
                    
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
