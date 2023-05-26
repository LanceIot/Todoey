//
//  SectionTableViewCell.swift
//  Todoey
//
//  Created by Админ on 07.03.2023.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    private lazy var cellView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.systemGray3.cgColor
        return view
    }()
    
    private lazy var priorityView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        return imageView
    }()
    
    private lazy var labelView = UIView()
    
    private lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Project daily stand-up"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.text = "At the conference center"
        label.font = UIFont.systemFont(ofSize: 12.5)
        label.textColor = .systemGray2
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
       let label = UILabel()
        label.text = "9:00 am"
        label.font = UIFont.systemFont(ofSize: 12.5)
        label.textColor = .systemGray2
        label.textAlignment = .right
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
    
    override func prepareForReuse() {
        priorityView.tintColor = .none
        nameLabel.text = ""
        descriptionLabel.text = ""
        dateLabel.text = ""
    }
    
    func configure(with item: TodoeyBDItem) {
        DispatchQueue.main.async {
            self.priorityView.tintColor = Constants.Values.colors[Int(item.priority) - 1]
            self.nameLabel.text = item.name
//            self.descriptionLabel.text = item.desc
            self.descriptionLabel.text = "\(item.isCompleted)"
            self.dateLabel.text = Date.toString(from: item.createdAt ?? Date())
        }
    }
}

//MARK: - Setup view and contraints methods
private extension ItemTableViewCell {
    
    func setupViews() {
        contentView.addSubview(cellView)
        cellView.addSubview(labelView)
        labelView.addSubview(nameLabel)
        labelView.addSubview(descriptionLabel)
        cellView.addSubview(dateLabel)
        cellView.addSubview(priorityView)
    }
    
    func setupConstraints() {
        cellView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.top.leading.trailing.equalToSuperview()
        }
        priorityView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(15)
            make.centerY.equalTo(nameLabel)
            
        }
        labelView.snp.makeConstraints { make in
            make.leading.equalTo(priorityView.snp.trailing).offset(20)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.675)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-15)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(25)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(labelView.snp.trailing)
            make.centerY.equalTo(nameLabel)
        }
    }
}
