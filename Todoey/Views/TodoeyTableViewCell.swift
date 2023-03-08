//
//  SectionTableViewCell.swift
//  Todoey
//
//  Created by Админ on 07.03.2023.
//

import UIKit

class TodoeyTableViewCell: UITableViewCell {
    
    static let IDENTIFIER = "SectionTableViewCell"
    
    private lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Section"
        label.font = UIFont.systemFont(ofSize: 20)
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
    
    func configure(name: String) {
        nameLabel.text = name
    }
}

//MARK: - Setup view and contraints methods
private extension TodoeyTableViewCell {
    
    func setupViews() {
        contentView.addSubview(nameLabel)
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
}
