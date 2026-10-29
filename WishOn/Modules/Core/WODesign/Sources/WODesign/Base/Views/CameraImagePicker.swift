import SwiftUI
import UIKit

public struct CameraImagePicker: UIViewControllerRepresentable {
    let onImage: (UIImage) -> Void
    let onDismiss: () -> Void
    
    public init(onImage: @escaping (UIImage) -> Void, onDismiss: @escaping () -> Void) {
        self.onImage = onImage
        self.onDismiss = onDismiss
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = context.coordinator
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(onImage: onImage, onDismiss: onDismiss)
    }
    
    public final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onImage: (UIImage) -> Void
        let onDismiss: () -> Void
        
        init(onImage: @escaping (UIImage) -> Void, onDismiss: @escaping () -> Void) {
            self.onImage = onImage
            self.onDismiss = onDismiss
        }
        
        public func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                onImage(image)
            }
            onDismiss()
        }
        
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onDismiss()
        }
    }
}
