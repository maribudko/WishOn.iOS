import SwiftUI
import UIKit

public struct DismissKeyboardOnOutsideTap: UIViewRepresentable {
    private var onDismiss: () -> Void

    public init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(onDismiss: onDismiss)
    }

    public func makeUIView(context: Context) -> UIView {
        let view = WindowTapInstaller()
        view.coordinator = context.coordinator
        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.onDismiss = onDismiss
        (uiView as? WindowTapInstaller)?.coordinator = context.coordinator
    }

    public final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var onDismiss: () -> Void

        init(onDismiss: @escaping () -> Void) {
            self.onDismiss = onDismiss
        }

        @objc func dismiss() {
            onDismiss()
        }

        public func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldReceive touch: UITouch
        ) -> Bool {
            var view = touch.view
            while let current = view {
                if current is UITextField || current is UITextView {
                    return false
                }
                let name = String(describing: type(of: current))
                if name.contains("TextField") || name.contains("TextView") {
                    return false
                }
                view = current.superview
            }
            return true
        }
    }
}

private final class WindowTapInstaller: UIView {
    var coordinator: DismissKeyboardOnOutsideTap.Coordinator?
    private var tap: UITapGestureRecognizer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        removeTap()
        guard let window, let coordinator else { return }
        let recognizer = UITapGestureRecognizer(target: coordinator, action: #selector(DismissKeyboardOnOutsideTap.Coordinator.dismiss))
        recognizer.cancelsTouchesInView = false
        recognizer.delegate = coordinator
        window.addGestureRecognizer(recognizer)
        tap = recognizer
    }

    deinit {
        removeTap()
    }

    private func removeTap() {
        if let tap {
            tap.view?.removeGestureRecognizer(tap)
        }
        tap = nil
    }
}
