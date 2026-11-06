import UIKit

extension UILabel {
    func setText(_ prefix: String, coloredValue value: String, color: UIColor) {
        let attributedString = NSMutableAttributedString(string: "\(prefix) ")
        attributedString.append(NSAttributedString(string: value, attributes: [.foregroundColor: color]))
        attributedText = attributedString
    }
}
