//
//  CreateItemViewController.swift
//  Todoey
//
//  Created by Админ on 16.03.2023.
//

import UIKit

protocol CUToMainViewControllerDelegate {
    func doRefresh()
}

final class CUViewController: UIViewController {
    
    var delegate: CUToMainViewControllerDelegate?
    
    private var sections: [TodoeyBDSection] = []
    private var selectedCell: Int = 0
    
    private var selectedPriority: Int16 = 1
    private var selectedItem: TodoeyBDItem?
    
    private lazy var contentView = UIView()
    
    private lazy var nameTextField: ViewTextField = {
       let viewTextField = ViewTextField()
        viewTextField.textField.placeholder = "What do you need to do?"
        return viewTextField
    }()
    
    private lazy var sectionCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CUSectionCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Identifiers.cuSectionCollectionViewCell)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var addSectionButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .init(white: 1, alpha: 0.4)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(addSectionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteSectionButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.backgroundColor = .init(white: 1, alpha: 0.4)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(deleteSectionButtonPressed), for: .touchUpInside)
        return button
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
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        configureNavBar()
        
        SectionManager.shared.delegate = self
        SectionManager.shared.fetchSections()
        
        sectionCollectionView.dataSource = self
        sectionCollectionView.delegate = self
        
        priorityPickerView.dataSource = self
        priorityPickerView.delegate = self
        
        setupViews()
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.doRefresh()
    }
}

//MARK: - Private methods
private extension CUViewController{
    
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
        if let name = nameTextField.textField.text, name != "" {
            ItemManager.shared.createItem(name: name, desc: "Please do this ASAP", priority: selectedPriority, section: sections[selectedCell])
            print("Succesfully created")
            dismiss(animated: true)
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
    
    @objc func addSectionButtonPressed() {
        let alert = UIAlertController(title: "New Section", message: "Create new section", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
            SectionManager.shared.createSection(with: text)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc func deleteSectionButtonPressed() {
        let alert = UIAlertController(title: "Delete section", message: "Are you sure you want to delete section?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            SectionManager.shared.deleteSection(section: self.sections[self.selectedCell])
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

//MARK: - Section manager delegate
extension CUViewController: SectionManagerDelegate {
    func didUpdateSections(with models: [TodoeyBDSection]) {
        sections = models
        DispatchQueue.main.async {
            self.sectionCollectionView.reloadData()
        }
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

//MARK: - Collection view data source methods
extension CUViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !sections.isEmpty {
            return sections.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if !sections.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.cuSectionCollectionViewCell, for: indexPath) as! CUSectionCollectionViewCell
            cell.configure(with: sections[indexPath.item].name ?? "Section", isSelected: indexPath.item == selectedCell)
            cell.layer.cornerRadius = 7.5
            cell.backgroundColor = UIColor(rgb: Int(sections[indexPath.item].color))
            cell.clipsToBounds = true
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK: - Collection view delegate methods
extension CUViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if !sections.isEmpty {
            let label = UILabel()
            label.text = sections[indexPath.item].name
            label.sizeToFit()
            return CGSize(width: label.frame.width + 30, height: label.frame.height + 20)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = indexPath.item
        DispatchQueue.main.async {
            collectionView.reloadData()
        }
    }
}

//MARK: - Setup view and contraints methods
private extension CUViewController {
    
    func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(nameTextField)
        contentView.addSubview(sectionCollectionView)
        contentView.addSubview(addSectionButton)
        contentView.addSubview(deleteSectionButton)
        contentView.addSubview(myImageView)
        contentView.addSubview(priorityLabel)
        contentView.addSubview(priorityPickerView)
        contentView.addSubview(submitButton)
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(75)
        }
        sectionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        addSectionButton.snp.makeConstraints { make in
            make.top.equalTo(sectionCollectionView.snp.bottom)
            make.trailing.equalToSuperview()
            make.size.equalTo(40)
        }
        addSectionButton.imageView?.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        deleteSectionButton.snp.makeConstraints { make in
            make.trailing.equalTo(addSectionButton.snp.leading).offset(-10)
            make.centerY.equalTo(addSectionButton)
            make.size.equalTo(40)
        }
        priorityLabel.snp.makeConstraints { make in
            make.top.equalTo(addSectionButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        priorityPickerView.snp.makeConstraints { make in
            make.top.equalTo(priorityLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(130)
        }
        submitButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
}
