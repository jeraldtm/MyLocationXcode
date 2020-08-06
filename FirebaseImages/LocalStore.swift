//
//  LocalStore.swift
//  FirebaseImages
//
//  Created by Thow on 8/5/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI
import Foundation
import Combine

class LocalStore: ObservableObject{
    @Published var items: [SavedPlace] = []
    @Published var currentIndex: Int = 0
    
  func addPlace(_ savedPlace: SavedPlace) {
    items.append(savedPlace)
  }
  
  func removePlace(_ savedPlace: SavedPlace) {
    if let index = items.firstIndex(where: { $0.id == savedPlace.id }) {
      items.remove(at: index)
    }
  }
  
  func updatePlace(_ savedPlace: SavedPlace) {
    if let index = self.items.firstIndex(where: { $0.id == savedPlace.id } ) {
        self.items[index] = savedPlace
    }
  }
}
