import UIKit
extension UILabel {
    func setText(_ prefix: String, coloredValue value: String, suffix: String = "", color: UIColor) {
        let attributed = NSMutableAttributedString(string: "\(prefix)  ")
        attributed.append(NSAttributedString(string: value, attributes: [.foregroundColor: color]))
        attributed.append(NSAttributedString(string: " \(suffix)"))
        attributedText = attributed
    }
}
