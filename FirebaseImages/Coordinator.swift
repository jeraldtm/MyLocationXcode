//
//  Coordinator.swift
//  FirebaseImages
//
//  Created by Thow Min Cham on 2/9/20.
//  Copyright © 2020 Thow Min Cham. All rights reserved.
//

import SwiftUI
class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  @Binding var isCoordinatorShown: Bool
  @Binding var imageInCoordinator: Image?
    @Binding var uiImage: UIImage?
    init(isShown: Binding<Bool>, image: Binding<Image?>, uiImage: Binding<UIImage?>) {
    _isCoordinatorShown = isShown
    _imageInCoordinator = image
    _uiImage = uiImage
  }
  func imagePickerController(_ picker: UIImagePickerController,
                didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
     imageInCoordinator = Image(uiImage: unwrapImage)
    uiImage = unwrapImage
     isCoordinatorShown = false
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
     isCoordinatorShown = false
  }
}
