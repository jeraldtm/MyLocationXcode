//
//  ListNearbyView.swift
//  FirebaseImages
//
//  Created by Thow Min Cham on 2/3/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI
import GooglePlaces

struct ListNearbyView: View {
    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    @State var likelyPlaces: [NearbyPlace] = []

    func listLikelyPlaces(){
        var placesClient: GMSPlacesClient!
        placesClient = GMSPlacesClient.shared()
        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: .name){ (placeLikelihoods, error) in
            guard error == nil else{
                print("Current Place error: \(error!.localizedDescription)")
                return
            }
            
            guard let placeLikelihoods = placeLikelihoods else{
                print("No places found.")
                return
            }
            
            for likelihood in placeLikelihoods{
                let place = likelihood.place
                self.likelyPlaces.append(NearbyPlace(name: place.name ?? ""))
            }
            print(self.likelyPlaces)
        }
    }
    
    var body: some View {
        VStack{
            List(likelyPlaces) { nearbyplace in
                    HStack{
                        Button(action:{
                            self.session.selectedPlace = nearbyplace.name
                            self.presentationMode.wrappedValue.dismiss()
                        }){
                            Text(nearbyplace.name)
                        }.buttonStyle(PlainButtonStyle())
                    }
                
            }
            .navigationBarTitle(Text("Nearby Places"))
            .listStyle(GroupedListStyle())
        }.onAppear(perform: listLikelyPlaces)
    }
}

struct NearbyPlace:Identifiable{
    var id = UUID()
    var name: String
}

struct NearbyPlaceCell: View {
    let nearbyPlaceName: String
    
    var body: some View {
        NavigationLink(destination: StoreView()
        ){
            VStack(alignment: .leading) {
                Text(nearbyPlaceName)
            }
        }
    }
}

#if DEBUG
struct ListNearbyView_Previews: PreviewProvider {
    static var previews: some View {
        ListNearbyView(likelyPlaces:[NearbyPlace(name:"test")])
    }
}
#endif
