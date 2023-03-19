//
//  CreateItemViewController.swift
//  Todoey
//
//  Created by Админ on 16.03.2023.
//

import UIKit

final class CUViewController: UIViewController {
    
    private var selectedPriority: Int16 = 1
    private var selectedSection: TodoeySection?
    private var selectedItem: Todoeyitem?
    private var isCreating: Bool = true
    
    private lazy var contentView = UIView()
    
    private lazy var nameTextField: ViewTextField = {
       let viewTextField = ViewTextField()
        viewTextField.textField.placeholder = "Name"
        return viewTextField
    }()
    
    private lazy var descTextField: ViewTextField = {
        let viewTextField = ViewTextField()
        viewTextField.textField.placeholder = "Description"
         return viewTextField
    }()
    
    private lazy var myImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.artframe")
        return imageView
    }()
    
    private lazy var priorityLabel: UILabel = {
       let label = UILabel()
        label.text = "Priority"
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var priorityPickerView: UIPickerView = {
       let pickerView = UIPickerView()
        return pickerView
    }()
    
    private lazy var submitButton: UIButton = {
       let button = UIButton()
        button.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        button.setTitle("Sumbit", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.backgroundColor = .systemBlue
        button.layer.borderWidth = 1
        button.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureNavBar()
        
        priorityPickerView.dataSource = self
        priorityPickerView.delegate = self
        
        setupViews()
        setupConstraints()
    }
    
    func configure(section: TodoeySection) {
        selectedSection = section
        isCreating = true
    }
    
    func configure(item: Todoeyitem) {
        isCreating = false
        selectedItem = item
        DispatchQueue.main.async {
            self.nameTextField.textField.text = item.name
            self.descTextField.textField.text = item.desc
            guard let imageData = item.image else { return }
            self.myImageView.image = UIImage(data: imageData)
        }
    }
}

//MARK: - Private methods
private extension CUViewController {
    
    func configureNavBar() {
        navigationItem.title = "Create Item"
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        let imageBtn = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = imageBtn
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func submitButtonPressed() {
        if let name = nameTextField.textField.text, name != "", let desc = descTextField.textField.text, desc != "" {
            guard let image = myImageView.image, let imageData = image.pngData() else { return }
            switch isCreating {
            case true:
                ItemManager.shared.createItem(name: name, desc: desc, priority: selectedPriority, imageData: imageData, section: selectedSection!)
            case false:
                ItemManager.shared.updateItem(item: selectedItem!, newName: name, desc: desc, imageData: imageData, priority: selectedPriority)
            }
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Nil data", message: "Please fill all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Return", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    @objc func didTapButton() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
}

//MARK: - Image Picker controller delegate methods
extension CUViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            myImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Picker View data source methods
extension CUViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Priority.allCases.count
    }
}

//MARK: - Picker View delegate methods
extension CUViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Priority.allCases[row].rawValue)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPriority = Priority.allCases[row].rawValue
    }
}

//MARK: - Setup view and contraints methods
private extension CUViewController {
    
    func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(nameTextField)
        contentView.addSubview(descTextField)
        contentView.addSubview(myImageView)
        contentView.addSubview(priorityLabel)
        contentView.addSubview(priorityPickerView)
        contentView.addSubview(submitButton)
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalTo(view).inset(7)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view).multipliedBy(0.1)
        }
        descTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view).multipliedBy(0.2)
        }
        myImageView.snp.makeConstraints { make in
            make.top.equalTo(descTextField.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(view).multipliedBy(0.15)
        }
        priorityLabel.snp.makeConstraints { make in
            make.top.equalTo(myImageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(view).multipliedBy(0.07)
        }
        priorityPickerView.snp.makeConstraints { make in
            make.top.equalTo(priorityLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view).multipliedBy(0.15)
        }
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(priorityPickerView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.height.equalTo(view).multipliedBy(0.08)
        }
    }
}
