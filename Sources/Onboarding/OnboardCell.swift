//
//  OnboardCell.swift
//  Onboarding
//

#if os(iOS)

import Color
import ConstraintKit
import Font
import NPKit
import UIKit

public class OnboardCell: NPView {
	public let iconView: NPImageView = {
		let view = NPImageView()
		view.tintColor = Color.label
		view.contentMode = .scaleAspectFill
		NSLayoutConstraint.activate([
			view.widthAnchor.constraint(equalToConstant: 54),
			view.heightAnchor.constraint(lessThanOrEqualToConstant: 54),
		])
		return view
	}()
	private var iconViewRatio: NSLayoutConstraint?

	public let titleLabel: NPLabel = {
		let view = NPLabel()
		view.font = Font.preferredFont(for: .title3, weight: .semibold)
		return view
	}()

	public let descriptionLabel = NPLabel()

	public init(icon: UIImage?, title: String?, description: String?) {
		super.init()

		self.iconView.image = icon
		self.iconViewRatio?.isActive = false
		if let size = icon?.size {
			self.iconViewRatio = self.iconView.heightAnchor.constraint(equalTo: self.iconView.widthAnchor, multiplier: size.height / size.width)
				.with(priority: .defaultHigh)
			self.iconViewRatio?.isActive = true
		}
		self.titleLabel.text = title
		let paragraphStyle = NSMutableParagraphStyle()
		if let description = description {
			let description = NSMutableAttributedString(string: description)
			description.addAttributes(
				[
					.kern : -0.5,
					.paragraphStyle : paragraphStyle,
				],
				range: NSRange(location: 0, length: description.length))
			self.descriptionLabel.attributedText = description
		}

		self.addSubview(self.iconView)
		self.addSubview(self.titleLabel)
		self.addSubview(self.descriptionLabel)

		NSLayoutConstraint.activate([
			self.iconView.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 1.5),
			self.iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			self.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: self.iconView.bottomAnchor, multiplier: 1.5),

			self.titleLabel.topAnchor.constraint(equalTo: self.iconView.topAnchor),
			self.titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: self.iconView.trailingAnchor, multiplier: 1.5),
			self.trailingAnchor.constraint(greaterThanOrEqualTo: self.titleLabel.trailingAnchor),

			self.descriptionLabel.topAnchor.constraint(equalToSystemSpacingBelow: self.titleLabel.bottomAnchor, multiplier: 0.25),
			self.descriptionLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
			self.descriptionLabel.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
			self.bottomAnchor.constraint(equalToSystemSpacingBelow: self.descriptionLabel.bottomAnchor, multiplier: 1.5),
		])
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

#endif
