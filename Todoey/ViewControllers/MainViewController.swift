//
//  ViewController.swift
//  Todoey
//
//  Created by Админ on 07.03.2023.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
        
    private var items = [TodoeyBDItem]()
    private var sections = [TodoeyBDSection]()
    private var selectedCell: Int = 0

    private lazy var contentView = UIView()
    
    private lazy var mainTableView: UITableView = {
       let tableView = UITableView()
        return tableView
    }()
        
    private lazy var searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.searchTextField.layer.cornerRadius = 15
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.backgroundColor = .systemBlue
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView?.tintColor = .white
        return searchBar
    }()
    
    private lazy var sectionCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MainSectionCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Identifiers.mainSectionCollectionViewCell)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var itemTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: Constants.Identifiers.itemTableViewCell)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var addItemButton: UIButton = {
       let button = UIButton()
        button.setTitle("Add new task", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 50
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        SectionManager.shared.delegate = self
        ItemManager.shared.delegate = self
//        SectionManager.shared.fetchSections()
//        ItemManager.shared.fetchItems()
        
        searchBar.delegate = self
        sectionCollectionView.dataSource = self
        sectionCollectionView.delegate = self
        itemTableView.dataSource = self
        itemTableView.delegate = self
        
        configureNavBar()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedCell = 0
        SectionManager.shared.fetchSections()
        ItemManager.shared.fetchItems()
        DispatchQueue.main.async {
            self.itemTableView.reloadData()
        }
    }
}

//MARK: - Private controller methods
private extension MainViewController {
    
    func configureNavBar() {
        navigationItem.title = "Todoey"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    @objc func addButtonPressed() {
        let controller = CUViewController()
        controller.delegate = self
        present(controller, animated: true)
    }
}

//MARK: - Section manager delegate
extension MainViewController: SectionManagerDelegate {
    func didUpdateSections(with models: [TodoeyBDSection]) {
        sections = models
        DispatchQueue.main.async {
            self.sectionCollectionView.reloadData()
            self.itemTableView.reloadData()
        }
    }
}

//MARK: - Item manager delegate
extension MainViewController: ItemManagerDelegate {
    
    func didUpdateItems(with models: [TodoeyBDItem]) {
        self.items = models
        DispatchQueue.main.async {
            self.sectionCollectionView.reloadData()
            self.itemTableView.reloadData()
        }
    }
    
    func didFailWith(with error: Error) {
        print("Following error appeared: ", error)
    }
}

//MARK: - Create Update to Main viewcontroller methods
extension MainViewController: CUToMainViewControllerDelegate {
    func doRefresh() {
        selectedCell = 0
        SectionManager.shared.delegate = self
        SectionManager.shared.fetchSections()
        ItemManager.shared.fetchItems()
        DispatchQueue.main.async {
            self.sectionCollectionView.reloadData()
            self.itemTableView.reloadData()
        }
    }
}

//MARK: - Search bar delegate methods
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch selectedCell {
        case 0:
            ItemManager.shared.fetchItems(with: searchText)
        default:
            ItemManager.shared.fetchItems(with: searchText, section: sections[selectedCell - 1])
        }
    }
}

//MARK: - Collection view data source methods
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.mainSectionCollectionViewCell, for: indexPath) as! MainSectionCollectionViewCell
        switch indexPath.row {
        case 0:
            cell.configure(with: "Undone", isSelected: indexPath.item == selectedCell, isUndone: true, amount: items.count)
        default:
            cell.configure(with: sections[indexPath.item-1].name ?? "Section", isSelected: indexPath.item == selectedCell, isUndone: false)
        }
        return cell
    }
}

//MARK: - Collection view delegate methods
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel()
        switch indexPath.item {
        case 0:
            label.text = "Undone"
        default:
            label.text = sections[indexPath.item-1].name
        }
        label.sizeToFit()
        return CGSize(width: label.frame.width + 40, height: label.frame.height + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedCell = indexPath.item
        switch selectedCell {
        case 0:
            ItemManager.shared.fetchItems()
        default:
            ItemManager.shared.fetchItems(section: sections[selectedCell - 1])
        }
        DispatchQueue.main.async {
            collectionView.reloadData()
            self.itemTableView.reloadData()
        }
    }
}

//MARK: - Table view data source methods
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.itemTableViewCell, for: indexPath) as! ItemTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.configure(with: items[indexPath.row])
        cell.clipsToBounds = true
        return cell
    }
}

//MARK: - Table view delegate methods
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch items[indexPath.row].isCompleted {
        case false:
            let alert = UIAlertController(title: "Complete", message: "Are you sure want to complete the task?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                ItemManager.shared.completeItem(item: self.items[indexPath.row], selectedCell: self.selectedCell)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        case true:
            let alert = UIAlertController(title: "Oops!", message: "Following task already completed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        }
    }
}

//MARK: - Setup view and contraints methods
private extension MainViewController {
    
    func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(searchBar)
        contentView.addSubview(sectionCollectionView)
        contentView.addSubview(itemTableView)
        view.addSubview(addItemButton)
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        searchBar.searchTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(7)
            make.leading.trailing.equalToSuperview()
        }
        sectionCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        itemTableView.snp.makeConstraints { make in
            make.top.equalTo(sectionCollectionView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(addItemButton.snp.top)
        }
        addItemButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
    }
}

