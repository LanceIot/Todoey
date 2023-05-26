//
//  CUSectionCollectionViewCell.swift
//  Todoey
//
//  Created by Админ on 15.04.2023.
//

import UIKit

class CUSectionCollectionViewCell: UICollectionViewCell {
    
    var cellSelected: Bool = false
    
    private lazy var title: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 7.5
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        contentView.layer.borderColor = .none
        contentView.layer.borderWidth = 0
        title.text = ""
        title.textColor = .black
    }
    
    func configure(with text: String, isSelected: Bool) {
        DispatchQueue.main.async {
            self.title.text = text
            if isSelected {
                self.contentView.layer.borderWidth = 3
                self.contentView.layer.borderColor = UIColor.white.cgColor
            }
        }
    }
}

//MARK: - Setup view and contraints methods
private extension CUSectionCollectionViewCell {
    
    func setupViews() {
        contentView.addSubview(title)
    }
    
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
