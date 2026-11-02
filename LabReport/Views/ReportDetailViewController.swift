import UIKit

class ReportDetailViewController: UIViewController {

    private let viewModel: ReportViewModel
    private lazy var summaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [
            createFieldStack(title: AppConstant.Titles.reportTitle,
                             subTitle: viewModel.reportName),
            createFieldStack(title: AppConstant.Titles.testPerformer,
                             subTitle: viewModel.testPerformer),
            createFieldStack(title: AppConstant.Titles.resultDateAndTime,
                             subTitle: viewModel.detailDate)
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])

        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .systemBackground
        tv.register(ObservationCell.self,
                    forCellReuseIdentifier: AppConstant.CellIdentifiers.observationCell)
        return tv
    }()

    init(viewModel: ReportViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = viewModel.reportName

        view.addSubview(summaryView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: summaryView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createFieldStack(title: String, subTitle: String) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [
            makeLabel(title, font: .systemFont(ofSize: 13, weight: .semibold), color: .secondaryLabel),
            makeLabel(subTitle, font: .systemFont(ofSize: 15, weight: .medium), color: .label)
        ])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }

    private func makeLabel(_ text: String, font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.numberOfLines = 0
        label.textColor = color
        return label
    }
}

extension ReportDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.observations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstant.CellIdentifiers.observationCell, for: indexPath) as? ObservationCell else {
            return UITableViewCell()
        }
        let observation = viewModel.observations[indexPath.row]
        cell.configure(with: observation)
        return cell
    }
}
