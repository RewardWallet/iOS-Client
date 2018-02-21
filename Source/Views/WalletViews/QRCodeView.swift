//
//  QRCodeView.swift
//  WalletKit
//
//  Copyright © 2017 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 11/27/17.
//

import UIKit

open class QRCodeView: UIView {
    
    // MARK: - Properties [Public]
    
    open var value: String? { didSet { generateQRCodeImage() } }
    
    // MARK: - Properties [Private]
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return imageView
    }()
    
    // MARK: - Initialization
    
    /// Initializes and returns a newly allocated BarcodeView object with the specified frame rectangle.
    ///
    /// - Parameter frame: The frame rectangle for the BarcodeView
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    /// Returns a BarcodeView object initialized from data in a given unarchiver.
    ///
    /// - parameter aDecoder: An unarchiver object.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - Methods [Public]
    
    /// Override to set up additional subviews in the BarcodeView
    open func setupViews() {
        backgroundColor = .white
        imageView.frame = frame
        addSubview(imageView)
    }
    
    // MARK: - Methods [Private]
    
    private func generateQRCodeImage() {
        
        imageView.image = nil
        
        guard let data = value?.data(using: .ascii), let filter = CIFilter(name: "CIQRCodeGenerator") else { return }
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10) // Higher scale = better quality
        
        guard let output = filter.outputImage?.transformed(by: transform) else { return }
        
        imageView.image = UIImage(ciImage: output)
    }
    
}
