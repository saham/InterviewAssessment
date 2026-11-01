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
    
    func configure(with observation: VitalObservationModel, valueColor: UIColor) {
        titleLabel.text = observation.testName ?? "Unknown Test"
        let observationValue = observation.value?.toString ?? ""
        let observationUnit = observation.unit ?? ""
       
        switch (observation.rangeLow, observation.rangeHigh) {
        case let (low?, high?):
            rangeLabel.text = "Normal Range  \(low) \(observationUnit) - \(high) \(observationUnit)"
        case let (low?, nil):
            rangeLabel.text = "Normal Range  ≥ \(low) \(observationUnit)"
        case let (nil, high?):
            rangeLabel.text = "Normal Range  ≤ \(high) \(observationUnit)"
        case (nil, nil):
            rangeLabel.text = "Normal Range  N/A"
        }
        resultLabel.setText("Result",
                            coloredValue: "\(observationValue) \(observationUnit)",
                            color: valueColor)
    }
}
