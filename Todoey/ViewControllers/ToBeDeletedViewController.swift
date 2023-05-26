////
////  ItemsViewController.swift
////  Todoey
////
////  Created by Админ on 07.03.2023.
////
//
//import UIKit
//
//final class ToBeDeletedViewController: UIViewController {
//    
//    private var sections = [TodoeyBDSection]()
//    
//    private lazy var contentView = UIView()
//    
//    private lazy var searchBar: UISearchBar = {
//       let searchBar = UISearchBar()
//        searchBar.searchBarStyle = .minimal
//        searchBar.placeholder = "Search"
//        searchBar.searchTextField.layer.cornerRadius = 20
//        searchBar.searchTextField.layer.masksToBounds = true
//        searchBar.searchTextField.backgroundColor = .systemBlue
//        searchBar.searchTextField.textColor = .white
//        searchBar.searchTextField.leftView?.tintColor = .white
//        return searchBar
//    }()
//    
//    private lazy var itemTableView: UITableView = {
//       let tableView = UITableView()
//        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.IDENTIFIER)
//        return tableView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
////        SectionManager.shared.delegate = self
////        SectionManager.shared.fetchSections()
//        
//        configureNavBar()
//        view.backgroundColor = .systemBackground
//        
//        itemTableView.dataSource = self
//        itemTableView.delegate = self
//        
//        setupViews()
//        setupConstraints()
//    }
//}
//
////MARK: - Section Manager delegate methods
//extension ToBeDeletedViewController: SectionManagerDelegate {
//    
//    func didUpdateSections(with models: [TodoeyBDSection]) {
//        self.sections = models
//        
//        DispatchQueue.main.async {
//            self.itemTableView.reloadData()
//        }
//    }
//}
//
////MARK: - Private controller methods
//private extension ToBeDeletedViewController {
//    
//    func configureNavBar() {
////        navigationItem.title = "Todoey"
////        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSectionButtonPressed))
////        navigationItem.rightBarButtonItem = add
////        navigationController?.navigationBar.tintColor = .label
////        navigationController?.navigationBar.prefersLargeTitles = true
//    }
//    
//    @objc func addButtonPressed() {
//        let alert = UIAlertController(title: "New Section", message: "Create new section", preferredStyle: .alert)
//        alert.addTextField()
//        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { _ in
//            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {return}
//            
//            SectionManager.shared.createSection(with: text)
//        }))
//        
//        present(alert, animated: true)
//    }
//}
//
////MARK: - Table view data source methods
//extension ToBeDeletedViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sections.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.IDENTIFIER, for: indexPath) as! ItemTableViewCell
//        cell.selectionStyle = .none
////        cell.configure(with: sections[indexPath.row])
//        return cell
//    }
//}
//
////MARK: - Table view delegate methods
//extension ToBeDeletedViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return view.frame.size.height * 0.1
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let viewController = MainViewController()
//        
////        viewController.configure(with: self.sections[indexPath.row])
//        navigationController?.pushViewController(viewController, animated: true)
//    }
//    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {        
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { _, _, _ in
//            SectionManager.shared.deleteSection(section: self.sections[indexPath.row])
//        })
//        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: { _, _, _ in
//            let alert = UIAlertController(title: "Update Section", message: "Update your section", preferredStyle: .alert)
//            alert.addTextField()
//            alert.textFields?.first?.text = self.sections[indexPath.row].name
//            alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { _ in
//                guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {return}
//                SectionManager.shared.updateSection(section: self.sections[indexPath.row], newName: text)
//            }))
//            
//            self.present(alert, animated: true)
//        })
//        editAction.image = UIImage(systemName: "square.and.pencil")
//        deleteAction.image = UIImage(systemName: "trash.fill")
//        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
//        config.performsFirstActionWithFullSwipe = true
//        return config
//    }
//}
//
////MARK: - Setup view and contraints methods
//private extension ToBeDeletedViewController {
//    
//    func setupViews() {
//        view.addSubview(contentView)
//        contentView.addSubview(searchBar)
//        contentView.addSubview(itemTableView)
//    }
//    
//    func setupConstraints() {
//        contentView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//        }
//        searchBar.snp.makeConstraints { make in
//            make.top.leading.trailing.equalToSuperview()
//        }
//        searchBar.searchTextField.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview().inset(7)
//            make.leading.trailing.equalToSuperview()
//        }
//        itemTableView.snp.makeConstraints { make in
//            make.top.equalTo(searchBar.snp.bottom).offset(10)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
//    }
//}
