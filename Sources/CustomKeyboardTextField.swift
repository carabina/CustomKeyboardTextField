import UIKit

protocol CustomKeyboardTextFieldType: class {
    func editingDidCancel()
}

extension UITextField: CustomKeyboardTextFieldType {
    func editingDidCancel() {
        text = nil
        attributedText = nil
        leftView = nil
        rightView = nil
    }
}

public class CustomKeyboardTextField<KeyboardViewProvider: CustomKeyboardProvider>: UITextField, UITextFieldDelegate {
    var provider: CustomKeyboardProvider {
        return KeyboardViewProvider()
    }

    private(set) var customKeyboardView: CustomKeyboardView? {
        didSet {
            inputView = customKeyboardView as? UIView
        }
    }

    private(set) var customKeyboardAccessoryView: CustomKeyboardAccessoryView? {
        didSet {
            inputAccessoryView = customKeyboardAccessoryView as? UIView
        }
    }

    public convenience init() {
        self.init(frame: CGRect.zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        delegate = self

        setupCustomKeyboard()
    }

    private func setupCustomKeyboard() {
        customKeyboardView = provider.inputView(with: self)
        customKeyboardAccessoryView = provider.inputAccessoryView(with: self)
    }

    override func editingDidCancel() {
        super.editingDidCancel()

        customKeyboardView?.reset()
        customKeyboardAccessoryView?.reset()
    }

    // MARK - UITextFieldDelegate

    public func textFieldDidBeginEditing(textField: UITextField) {
        customKeyboardView?.updateTextField()
    }
}
