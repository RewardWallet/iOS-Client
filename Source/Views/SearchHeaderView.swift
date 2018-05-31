//
//  FeaturedHeaderView.swift
//  Evocial
//
//  Created by Nathan Tannar on 3/9/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import IGListKit

final class SearchHeaderView: UIView {
    
    // MARK: - Properties
    
    weak var viewController: UIViewController?
    
    lazy var textInputView = TextInputAccessoryView(view: self.searchBar)
    
    var searchBarDelegate: UITextFieldDelegate? {
        get { return searchBar.delegate }
        set { searchBar.delegate = newValue }
    }
    
    // MARK: - Subviews
    
    private let searchBar = UIAnimatedTextField(style: Stylesheet.TextFields.search) {
        $0.borderInactiveColor = UIColor.white
        $0.borderActiveColor = .white
        $0.placeholderColor = .white
        $0.borderThickness.active = 3
        $0.borderThickness.inactive = 1
        $0.tintColor = .white
        $0.textColor = .white
        $0.font = Stylesheet.headerFont
        $0.placeholder = "Search"
        $0.clearButtonMode = .always
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        let frame = frame != .zero ? frame : CGRect(x: 0, y: 0, width: 300, height: 60)
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        backgroundColor = .primaryColor
        
        addSubview(searchBar)
        
        searchBar.inputAccessoryView = textInputView
        searchBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, leftConstant: 24, bottomConstant: 12, rightConstant: 24, heightConstant: 44)
        
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return searchBar.resignFirstResponder()
    }
    
}
