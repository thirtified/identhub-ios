//
//  ActionRoundedButton.swift
//  IdentHubSDK
//

import UIKit

/// UIButton which has three adoptable appearances.
class ActionRoundedButton: UIButton {

    enum Constants {
        enum FontSize {
            static let medium: CGFloat = 14
        }

        enum ConstraintsSize {
            static let height: CGFloat = 48
        }
    }

    enum Appearance {
        case orange
        case dimmed
        case inactive
        case verifying
    }

    /// Current button appearance.
    var currentAppearance = Appearance.orange {
        didSet {
            let colors: (background: UIColor, text: UIColor)
            switch currentAppearance {
            case .orange:
                isEnabled = true
                colors = (UIColor.sdkColor(.primaryAccent), .white)
            case .dimmed:
                isEnabled = true
                colors = (UIColor.sdkColor(.base05), .sdkColor(.base100))
            case .inactive:
                isEnabled = false
                colors = (UIColor.sdkColor(.base25), .sdkColor(.base100))
            case .verifying:
                isEnabled = false
                setTitle(Localizable.Common.verifying, for: .disabled)
                colors = (UIColor.sdkColor(.base25), .white)
            }

            backgroundColor = colors.background
            setTitleColor(colors.text, for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    private func configureUI() {
        titleLabel?.font = .systemFont(ofSize: Constants.FontSize.medium, weight: .bold)
        layer.cornerRadius = 4

        addConstraints { [
            $0.equalConstant(.height, Constants.ConstraintsSize.height)
        ]
        }
    }
}
