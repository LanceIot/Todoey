//
//  ViewController.swift
//  Todoey
//
//  Created by Админ on 07.03.2023.
//

import UIKit
import SnapKit

final class ItemViewController: UIViewController {
    
    private var items = [Todoeyitem]()
    private var selectedSection: TodoeySection?

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private lazy var contentView = UIView()
        
    private lazy var searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private lazy var itemTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TodoeyTableViewCell.self, forCellReuseIdentifier: TodoeyTableViewCell.IDENTIFIER)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        ItemManager.shared.delegate = self
        ItemManager.shared.fetchItems(section: selectedSection!)
        
        itemTableView.dataSource = self
        itemTableView.delegate = self
        searchBar.delegate = self
        
        configureNavBar()
        setupViews()
        setupConstraints()
        
    }
    
    func configure(with section: TodoeySection) {
        self.selectedSection = section
    }
}

//MARK: - Private controller methods
private extension ItemViewController {
    
    func configureNavBar() {
        navigationItem.title = "Todoey"
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = add
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func addButtonPressed() {
        guard let selectedSection else { return }
        let controller = CUViewController()
        controller.configure(section: selectedSection)
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - Data manager delegate methods
extension ItemViewController: ItemManagerDelegate {
    
    func didUpdateItems(with models: [Todoeyitem]) {
        self.items = models
        DispatchQueue.main.async {
            self.itemTableView.reloadData()
        }
    }
    
    func didFailWith(with error: Error) {
        print("Following error appeared: ", error)
    }
}

//MARK: - Table view data source methods
extension ItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoeyTableViewCell.IDENTIFIER, for: indexPath) as! TodoeyTableViewCell
        cell.selectionStyle = .none
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

//MARK: - Table view delegate methods
extension ItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ItemDescriptionViewController()
        
        viewController.configure(item: items[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 5
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { _, _, _ in
            ItemManager.shared.deleteItem(item: self.items[indexPath.row], section: self.selectedSection!)
        })
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: { _, _, _ in
            let controller = CUViewController()
            controller.configure(item: self.items[indexPath.row])
            self.navigationController?.pushViewController(controller, animated: true)
        })
        editAction.image = UIImage(systemName: "square.and.pencil")
        deleteAction.image = UIImage(systemName: "trash.fill")
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}

//MARK: - Search bar delegate methods
extension ItemViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        ItemManager.shared.fetchItems(with: searchText, section: selectedSection!)
    }
}

//MARK: - Setup view and contraints methods
private extension ItemViewController {
    
    func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(searchBar)
        contentView.addSubview(itemTableView)
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        searchBar.searchTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(7)
            make.leading.trailing.equalToSuperview()
        }
        itemTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

