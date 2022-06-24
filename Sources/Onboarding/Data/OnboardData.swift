//
//  OnboardData.swift
//  Onboarding
//

#if os(iOS)

import UIKit

public struct OnboardData {
	public var count: Int {
		self.rows.count
	}

	public let icon: UIImage
	public let title: NSMutableAttributedString
	public let buttonText: String
	private var rows = [OnboardFeature]()

	public init(icon: UIImage, title: NSMutableAttributedString, buttonText: String) {
		self.icon = icon
		self.title = title
		self.buttonText = buttonText
	}

	public subscript(index: Int) -> OnboardFeature {
		self.rows[index]
	}

	public mutating func add(row: OnboardFeature) {
		self.rows.append(row)
	}

	public mutating func remove(at index: Int) {
		self.rows.remove(at: index)
	}
}

extension OnboardData: Collection {
	public var startIndex: Int { self.rows.startIndex }
	public var endIndex: Int { self.rows.endIndex }

	public func index(after i: Int) -> Int {
		self.rows.index(after: i)
	}
}

#endif
