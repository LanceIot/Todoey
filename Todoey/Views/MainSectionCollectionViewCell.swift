//
//  MainSectionCollectionViewCell.swift
//  Todoey
//
//  Created by Админ on 17.04.2023.
//

import UIKit

class MainSectionCollectionViewCell: UICollectionViewCell {
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var counter: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .systemRed
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.layer.cornerRadius = 9
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = contentView.frame.height / 2
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        title.text = ""
        title.textColor = .black
        contentView.backgroundColor = .none
        counter.removeFromSuperview()
    }
    
    func configure(with text: String, isSelected: Bool, isUndone: Bool, amount: Int? = 0) {
        DispatchQueue.main.async {
            self.title.text = text
            if isSelected {
                self.title.textColor = .blue
                self.contentView.backgroundColor = UIColor(rgb: Constants.Colors.selectedMainCell)
                if isUndone {
                    self.contentView.addSubview(self.counter)
                    self.counter.snp.makeConstraints { make in
                        make.top.equalToSuperview().inset(1)
                        make.trailing.equalToSuperview().inset(5)
                        make.size.equalTo(18)
                    }
                    self.counter.text = "\(amount!)"
                }
            }
            
        }
    }
}

//MARK: - Setup view and contraints methods
private extension MainSectionCollectionViewCell {
    
    func setupViews() {
        contentView.addSubview(title)
    }
    
    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

