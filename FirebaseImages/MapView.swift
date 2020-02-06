//
//  MapView.swift
//  FirebaseImages
//
//  Created by Thow Min Cham on 2/5/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var latitude: String = "34.011286"
    var longitude: String = "-116.166868"
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: Double(self.latitude)!, longitude: Double(self.longitude)!)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate =  coordinate
        view.addAnnotation(annotation)
    }
}

struct MapView_Preview: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
