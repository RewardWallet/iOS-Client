//
//  FBAnnotationClusterTemplate.swift
//  FBAnnotationClusteringSwift
//
//  Created by Antoine Lamy on 23/9/2016.
//  Copyright (c) 2016 Antoine Lamy. All rights reserved.
//

import UIKit

public enum FBAnnotationClusterDisplayMode {
	case SolidColor(sideLength: CGFloat, color: UIColor)
	case Image(imageName: String)
}

public struct FBAnnotationClusterTemplate {

	let range: Range<Int>?
	let displayMode: FBAnnotationClusterDisplayMode

	public var borderWidth: CGFloat = 0

	public var fontSize: CGFloat = 15
	public var fontName: String?

	public var font: UIFont? {
		if let fontName = fontName {
			return UIFont(name: fontName, size: fontSize)
		} else {
			return UIFont.boldSystemFont(ofSize: fontSize)
		}
	}

	public init(range: Range<Int>?, displayMode: FBAnnotationClusterDisplayMode) {
		self.range = range
		self.displayMode = displayMode
	}

	public init (range: Range<Int>?, sideLength: CGFloat) {
		self.init(range: range, displayMode: .SolidColor(sideLength: sideLength,
		                                                 color: .primaryColor))
	}
}
