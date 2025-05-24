//
//  TextFieldExtensions.swift
//  SwiftProject2
//
//  Created by georgeHsu on 2025/5/24.
//

import Foundation
import SwiftUI
import UIKit

struct CopyableTextField: UIViewRepresentable {
    var text: String

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.text = text
        textField.borderStyle = .roundedRect
        textField.isEnabled = true
        textField.isUserInteractionEnabled = true
        textField.addTarget(context.coordinator, action: #selector(Coordinator.preventEditing), for: .editingDidBegin)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        @objc func preventEditing(_ sender: UITextField) {
            sender.resignFirstResponder()
        }
    }
}
