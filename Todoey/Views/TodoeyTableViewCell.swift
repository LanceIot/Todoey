//
//  SectionTableViewCell.swift
//  Todoey
//
//  Created by Админ on 07.03.2023.
//

import UIKit

class TodoeyTableViewCell: UITableViewCell {
    
    static let IDENTIFIER = "SectionTableViewCell"
    
    private lazy var wholeView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemMint
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var labelView = UIView()
    
    private lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Section"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
       let label = UILabel()
        label.text = "Date"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: Todoeyitem) {
        DispatchQueue.main.async {
            self.nameLabel.text = item.name
            self.dateLabel.text = Date.toString(from: item.createdAt!)
            switch item.priority {
            case 1: self.wholeView.backgroundColor = .systemRed
            case 2: self.wholeView.backgroundColor = .systemYellow
            default: self.wholeView.backgroundColor = .systemGreen
            }
        }
    }
    
    func configure(with section: TodoeySection) {
        DispatchQueue.main.async {
            self.nameLabel.text = section.name
            self.dateLabel.text = Date.toString(from: section.createdAt!)
        }
    }
}

//MARK: - Setup view and contraints methods
private extension TodoeyTableViewCell {
    
    func setupViews() {
        contentView.addSubview(wholeView)
        wholeView.addSubview(labelView)
        labelView.addSubview(nameLabel)
        labelView.addSubview(dateLabel)
    }
    
    func setupConstraints() {
        wholeView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(3)
            make.leading.trailing.equalToSuperview()
        }
        labelView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(7)
            make.width.equalToSuperview().multipliedBy(0.75)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
