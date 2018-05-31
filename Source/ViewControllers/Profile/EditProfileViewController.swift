//
//  EditProfileViewController.swift
//  RewaletrdWal
//
//  Created by Nathan Tannar on 1/2/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import Former
import Parse
import Kingfisher

final class EditProfileViewController: RWViewController {
    
    // MARK: - Properties
    
    let user: User
    let userModified = User()
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private lazy var former = Former(tableView: self.tableView)
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)
    
    fileprivate lazy var pictureImageRow: LabelRowFormer<ProfileImageCell> = {
        LabelRowFormer<ProfileImageCell>(instantiateType: .Nib(nibName: "ProfileImageCell")) {
                $0.iconView.kf.setImage(with: self.user.picture)
                $0.iconView.apply(Stylesheet.ImageViews.filled)
                $0.iconView.backgroundColor = .offWhite
            }.configure {
                $0.text = "Select from your library"
                $0.rowHeight = 60
            }.onSelected { [weak self] row in
                self?.former.deselect(animated: true)
                let imagePicker = ImagePickerController()
                imagePicker.onImageSelection { [weak self] image in
                    guard let image = image, let imageData = UIImageJPEGRepresentation(image, 0.75) else { return }
                    row.cell.iconView.image = image
                    if let key = self?.user.picture?.url {
                        KingfisherManager.shared.cache.removeImage(forKey: key)
                    }
                    let file = PFFile(name: "picture.jpg", data: imageData)
                    self?.userModified.picture = file
                }
                self?.present(imagePicker, animated: true, completion: nil)
        }
    }()
    
    // MARK: - Initialization
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(didTapSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapCancel))
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.contentInset.bottom = 10
        buildForm()
    }
    
    func buildForm() {
        
        // Create RowFomers
        
        let nameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
                $0.titleLabel.text = "Full Name"
                $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your full name"
                $0.text = self.user.fullname
            }.onTextChanged { [weak self] in
                if $0.isEmpty {
                    self?.userModified.fullname = self?.user.username
                    self?.userModified.fullname_lower = self?.user.username?.lowercased()
                } else {
                    self?.userModified.fullname = $0
                    self?.userModified.fullname_lower = $0.lowercased()
                }
        }
        
        let emailRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
                $0.titleLabel.text = "Email"
                $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.text = self.user.email ?? self.user.username
                $0.enabled = false
        }
        
        let locationRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
                $0.titleLabel.text = "Location"
                $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure { [weak self] in
                $0.placeholder = "Add your location"
                $0.text = self?.user.address
            }.onTextChanged { [weak self] in
                self?.userModified.address = $0
        }
        
        let phoneRow = TextFieldRowFormer<PhoneFieldCell>(instantiateType: .Nib(nibName: "PhoneFieldCell")) { [weak self] in
                $0.titleLabel.text = "Phone"
                $0.textField.keyboardType = .numberPad
                $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure { [weak self] in
                $0.placeholder = "Add your phone number"
                if let num = self?.user.phone {
                    $0.text = "\(num)"
                }
            }.onTextChanged { [weak self] in
                self?.userModified.phone = NSNumber(value: Int($0.digits) ?? 9999999999)
        }
    
        let changePasswordRow = LabelRowFormer<FormLabelCell>() {
                $0.titleLabel.textColor = .primaryColor
                $0.titleLabel.font = .boldSystemFont(ofSize: 15)
                $0.accessoryType = .disclosureIndicator
            }.configure {
                $0.text = "Change Password"
            }.onSelected { [weak self] _ in
                self?.former.deselect(animated: true)
                self?.didTapChangePassword()
        }
        
        // Create Headers
        
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.viewHeight = 40
                    $0.text = text
            }
        }
        
        // Create SectionFormers
        
        let imageSection = SectionFormer(rowFormer: pictureImageRow)
            .set(headerViewFormer: createHeader("Profile Image"))
        let aboutSection = SectionFormer(rowFormer: emailRow, nameRow, phoneRow, locationRow)
            .set(headerViewFormer: createHeader("Details"))
        
        let securitySection = SectionFormer(rowFormer: changePasswordRow)
            .set(headerViewFormer: createHeader("Security"))
        
        former.append(sectionFormer: imageSection, aboutSection, securitySection)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }

    }
    
    // MARK: - Networking / User Actions
    
    @objc
    func didTapSave() {
        API.shared.showProgressHUD(ignoreUserInteraction: true)
        user.fullname = userModified.fullname ?? user.fullname
        user.fullname_lower = userModified.fullname_lower ?? user.fullname_lower
        user.phone = userModified.phone ?? user.phone
        user.address = userModified.address ?? user.address
        user.picture = userModified.picture ?? user.picture
        user.saveInBackground { [weak self] success, error in
            API.shared.dismissProgressHUD()
            if success {
                self?.handleSuccess("Profile Updated")
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.handleError(error?.localizedDescription)
            }
        }
    }
    
    @objc
    func didTapCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    func didTapChangePassword() {
        
        let alert = UIAlertController(title: "Change Password", message: "Please enter your current password", preferredStyle: .alert)
        alert.removeTransparency()
        alert.view.tintColor = .primaryColor
        alert.addTextField {
            $0.placeholder = "Password"
            $0.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.verifyCurrentPassword(with: alert.textFields?.first?.text ?? "")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func verifyCurrentPassword(with password: String) {
        
        guard let email = User.current()?.username else { return }
        User.loginInBackground(email: email, password: password) { [weak self] success, error in
            if success {
                self?.promptCreateNewPassword()
            } else {
                self?.handleError(error?.localizedDescription)
            }
        }
    }
    
    func promptCreateNewPassword() {
        
        let alert = UIAlertController(title: "Change Password", message: "Please enter your new password", preferredStyle: .alert)
        alert.removeTransparency()
        alert.view.tintColor = .primaryColor
        alert.addTextField {
            $0.placeholder = "New Password"
            $0.isSecureTextEntry = true
        }
        alert.addTextField {
            $0.placeholder = "Confirm Password"
            $0.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            let newPassword = alert.textFields?.first?.text ?? ""
            let confirmPassword = alert.textFields?.last?.text ?? ""
            if newPassword == confirmPassword {
                self?.user.password = newPassword
                self?.user.saveInBackground(block: { success, error in
                    if success {
                        self?.handleSuccess("Password Updated")
                    } else {
                        self?.handleError(error?.localizedDescription)
                    }
                })
            } else {
                self?.handleError("The passwords do not match")
                self?.promptCreateNewPassword()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
