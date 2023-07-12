//
//  ImagePicker.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-04-29.
//

import SwiftUI



struct ImagePicker: UIViewControllerRepresentable {
    // Environment and binding variables
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    @State private var showCropView: Bool = false
    let sourceType: UIImagePickerController.SourceType

    // Make UIViewController
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = sourceType
        return imagePicker
    }

    // Update UIViewController
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }

    // Make Coordinator
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    // Coordinator class
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        // didFinishPickingMediaWithInfo delegate method
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        // imagePickerControllerDidCancel delegate method
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


// Preview provider
struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker(selectedImage: .constant(nil), sourceType: .photoLibrary)
    }
}
