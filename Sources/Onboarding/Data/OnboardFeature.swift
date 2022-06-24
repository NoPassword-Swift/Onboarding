//
//  OnboardFeature.swift
//  Onboarding
//

#if os(iOS)

import UIKit

public struct OnboardFeature {
	public let icon: UIImage
	public let title: String
	public let description: String

	public init(icon: UIImage, title: String, description: String) {
		self.icon = icon
		self.title = title
		self.description = description
	}
}

#endif
