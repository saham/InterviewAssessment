import UIKit
class ObservationCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rangeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(resultLabel)
        contentView.addSubview(rangeLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            resultLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            resultLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            rangeLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 4),
            rangeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            rangeLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            rangeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with observation: VitalObservationModel) {
        titleLabel.text = observation.testName ?? "Unknown Test"
        let value = observation.value?.toString ?? ""
        let unit = observation.unit ?? ""
        rangeLabel.text = "Normal Range  \(rangeText(for: observation, unit: unit))"
        resultLabel.setText("Result",
                            coloredValue: "\(value) \(unit)",
                            color: observation.status.color)
    }
    
    private func rangeText(for observation: VitalObservationModel, unit: String) -> String {
        switch (observation.rangeLow, observation.rangeHigh) {
        case let (low?, high?): return "\(low) \(unit) - \(high) \(unit)"
        case let (low?, nil):   return "≥ \(low) \(unit)"
        case let (nil, high?):  return "≤ \(high) \(unit)"
        case (nil, nil):        return "N/A"
        }
    }
}
