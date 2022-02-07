import Combine
import UIKit

class ViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var segmentedPicker: UISegmentedControl = {
        let picker = UISegmentedControl(frame: .zero)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.font = .preferredFont(forTextStyle: .title3)
        return descriptionLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        configurePickerActions()
        
        // Assign the highlighted segmented control to
        // the current weight preference.
        UserDefaults.standard.publisher(for: \.unitPreference)
            .assign(to: \.selectedSegmentIndex, on: segmentedPicker)
            .store(in: &cancellables)
        
        // Update the label when the preference changes.
        UserDefaults.standard.publisher(for: \.unitPreference)
            .compactMap { WeightUnitPreference(rawValue: $0) }
            .map { $0.description }
            .assign(to: \.text, on: descriptionLabel)
            .store(in: &cancellables)
    }
    
    private func configurePickerActions() {
        let action1 = UIAction(title: WeightUnitPreference.pounds.description,
                               handler: { action in
            UserDefaults.standard.unitPreference = WeightUnitPreference.pounds.rawValue
        })
        
        let action2 = UIAction(title: WeightUnitPreference.kilograms.description,
                               handler: { action in
            UserDefaults.standard.unitPreference = WeightUnitPreference.kilograms.rawValue
        })
       
        segmentedPicker.insertSegment(action: action1,
                                      at: 0,
                                      animated: false)
        
        segmentedPicker.insertSegment(action: action2,
                                      at: 1,
                                      animated: false)
    }
    
    private func setupLayout() {
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 40,
                                                                leading: 20,
                                                                bottom: 20,
                                                                trailing: 20)
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.text = "Current preference:"
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical

        view.addSubview(segmentedPicker)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            
            segmentedPicker.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            segmentedPicker.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            segmentedPicker.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30.0),
        ])
    }
}

