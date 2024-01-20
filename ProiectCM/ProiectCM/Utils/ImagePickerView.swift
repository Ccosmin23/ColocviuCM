//
//  ImagePickerView.swift
//  MoveApp
//
//  Created by Cosmin Cosan on 06.09.2021.
//

//import Foundation
import SwiftUI
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    let didSelectImage: (UIImage) -> Void
    
    func makeCoordinator() -> ImagePickerViewCoordinator {
        ImagePickerViewCoordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
//        pickerController.cameraCaptureMode = .photo
        pickerController.delegate = context.coordinator
        return pickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        var imagePicker: ImagePickerView
        
        init(_ imagePicker: ImagePickerView) {
            self.imagePicker = imagePicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imagePicker.didSelectImage(image)
            }
            self.imagePicker.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.imagePicker.isPresented = false
        }
    }
}
