//
//  OnboardingController.swift
//  Onboarding
//

#if os(iOS)

import Color
import ConstraintKit
import Font
import NPKit
import UIKit

public class OnboardingController: NPViewController {
	public var data: OnboardData
	public var completion: () -> Void

	private lazy var topEffectView: UIVisualEffectView = {
		let effect = UIBlurEffect(style: .regular)
		let view = UIVisualEffectView(effect: effect)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private lazy var scrollView: UIScrollView = {
		let view = UIScrollView()
		view.contentInsetAdjustmentBehavior = .never
		view.automaticallyAdjustsScrollIndicatorInsets = false
		view.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(self.titleStack)
		view.addSubview(self.featureStack)
		NSLayoutConstraint.activate([
			view.contentLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			view.contentLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),

			self.titleStack.centerXAnchor.constraint(equalTo: view.contentLayoutGuide.centerXAnchor),
			self.titleStack.widthAnchor.constraint(equalTo: view.contentLayoutGuide.widthAnchor, multiplier: 0.7),

			self.featureTopConstraint,
			self.featureStack.leadingAnchor.constraint(equalTo: self.titleStack.leadingAnchor),
			self.featureStack.trailingAnchor.constraint(equalTo: self.titleStack.trailingAnchor),
			view.contentLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: self.featureStack.bottomAnchor, multiplier: 2),
		])
		return view
	}()
	private lazy var titleCenterConstraint = self.view.centerYAnchor.constraint(equalTo: self.titleStack.bottomAnchor, constant: 2)
	private lazy var titleTopConstraint = self.titleStack.topAnchor.constraint(equalToSystemSpacingBelow: self.scrollView.contentLayoutGuide.topAnchor, multiplier: 8)
	private lazy var featureTopConstraint = self.featureStack.topAnchor.constraint(equalToSystemSpacingBelow: self.titleStack.bottomAnchor, multiplier: 5.25)

	private lazy var titleStack: UIStackView = {
		let view = UIStackView()
		view.axis = .vertical
		view.alignment = .leading
		view.spacing = 42
		view.translatesAutoresizingMaskIntoConstraints = false
		view.addArrangedSubview(self.iconView)
		view.addArrangedSubview(self.titleView)
		return view
	}()
	private lazy var iconView: UIImageView = {
		let view = UIImageView()
		view.clipsToBounds = true
		view.layer.cornerRadius = 20
		view.layer.cornerCurve = .continuous
		view.image = self.data.icon
		view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			view.widthAnchor.constraint(equalToConstant: 80),
			view.heightAnchor.constraint(equalToConstant: 80),
		])
		return view
	}()
	private lazy var titleView: UILabel = {
		let view = NPLabel()
		view.font = Font.scaledSystemFont(ofSize: 47, weight: .heavy)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineHeightMultiple = 0.85
		let title = self.data.title
		title.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: title.length))
		view.attributedText = self.data.title
		return view
	}()

	private lazy var featureStack: UIStackView = {
		let view = NPStackView()
		view.axis = .vertical
		view.alignment = .fill
		view.spacing = 2
		for row in self.data {
			view.addArrangedSubview(OnboardCell(icon: row.icon, title: row.title, description: row.description))
		}
		return view
	}()

	private lazy var bottomContainer: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(self.bottomEffectView)
		view.addSubview(self.button)
		self.bottomEffectView.fillSuperview().activate()
		NSLayoutConstraint.activate([
			self.button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			self.button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
			self.button.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 4),
			view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: self.button.bottomAnchor, multiplier: 5)
		])
		return view
	}()
	private let bottomEffectView: UIVisualEffectView = {
		let effect = UIBlurEffect(style: .regular)
		let view = UIVisualEffectView(effect: effect)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	private lazy var button: UIButton = {
		let view = UIButton(type: .system)
		if let title = view.titleLabel {
			title.font = Font.preferredFont(for: .title3, weight: .bold)
			title.adjustsFontForContentSizeCategory = true
			title.translatesAutoresizingMaskIntoConstraints = false
			title.centerInSuperview().activate()
			view.heightAnchor.constraint(equalTo: title.heightAnchor, multiplier: 2.5).isActive = true
		}
		view.setTitle(self.data.buttonText, for: .normal)
		view.setTitleColor(.white, for: .normal)
		view.backgroundColor = Color.tintColor
		view.layer.cornerRadius = 15
		view.layer.cornerCurve = .continuous
		view.translatesAutoresizingMaskIntoConstraints = false
		view.onTouchUpInside { [weak self] _ in self?.completion() }
		return view
	}()
	private lazy var bottomHiddenConstraint = self.bottomContainer.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 100)
	private lazy var bottomBottomConstraint = self.bottomContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)

	public init(data: OnboardData, completion: @escaping () -> Void) {
		self.data = data
		self.completion = completion
		super.init()
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		self.scrollView.delegate = self

		self.view.addSubview(self.scrollView)
		self.view.addSubview(self.topEffectView)
		self.view.addSubview(self.bottomContainer)

		self.scrollView.fillSuperview().activate()
		NSLayoutConstraint.activate([
			self.titleCenterConstraint,
			self.bottomHiddenConstraint,

			self.topEffectView.topAnchor.constraint(equalTo: self.view.topAnchor),
			self.topEffectView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			self.topEffectView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			self.topEffectView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),

			self.bottomContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			self.bottomContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
		])
	}

	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		self.titleStack.alpha = 0
		self.titleStack.transform = CGAffineTransform(scaleX: 0.66, y: 0.66)

		for view in self.featureStack.arrangedSubviews {
			view.alpha = 0
			self.featureStack.setCustomSpacing(200, after: view)
		}
		self.featureTopConstraint.constant += 50
	}

	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		UIView.animate(withDuration: 0.66, delay: 0, options: .curveEaseOut) {
			self.titleStack.alpha = 1
			self.titleStack.transform = .identity
		} completion: { _ in
			self.view.layoutIfNeeded()

			UIView.animate(withDuration: 0.66, delay: 0.33, options: .curveEaseOut) {
				self.iconView.alpha = 0
				self.iconView.isHidden = true
				self.titleCenterConstraint.isActive = false
				self.titleTopConstraint.isActive = true
				self.featureTopConstraint.constant -= 50
				self.view.layoutIfNeeded()
			}

			let views = self.featureStack.arrangedSubviews
			for (i, view) in views.enumerated() {
				UIView.animate(withDuration: 0.66, delay: 0.44 + Double(i) * 0.03, options: .curveEaseOut) {
					view.alpha = 1
					self.featureStack.setCustomSpacing(0, after: view)
				}
			}

			UIView.animate(withDuration: 0.66, delay: 0.44 + 3 * 0.03, options: .curveEaseOut) {
				self.bottomHiddenConstraint.isActive = false
				self.bottomBottomConstraint.isActive = true
				self.view.layoutIfNeeded()
			}
		}
	}

	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		var inset = UIEdgeInsets.zero
		inset.top = self.topEffectView.frame.height
		inset.bottom = self.bottomContainer.frame.height
		self.scrollView.contentInset = inset
		self.scrollView.scrollIndicatorInsets = inset

		self.scrollViewDidScroll(self.scrollView)
	}
}

extension OnboardingController: UIScrollViewDelegate {
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset.y
		let height = scrollView.frame.height
		let size = scrollView.contentSize.height
		UIView.animate(withDuration: 0.2) {
			self.topEffectView.alpha = offset + self.topEffectView.frame.height > (4 * 8) ? 1 : 0
			self.bottomEffectView.alpha = offset + height - self.bottomEffectView.frame.height < size - (1 * 8) ? 1 : 0
		}
	}
}

#endif
