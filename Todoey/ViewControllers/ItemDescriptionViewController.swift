//
//  ItemDescriptionViewController.swift
//  Todoey
//
//  Created by Админ on 20.03.2023.
//

import UIKit

class ItemDescriptionViewController: UIViewController {
    
    private lazy var myImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Title"
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    private lazy var descLabel: UILabel = {
       let label = UILabel()
        label.text = "Description"
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        
        setupViews()
        setupConstraints()
    }
    
    func configure(item: TodoeyBDItem) {
        DispatchQueue.main.async {
            self.titleLabel.text = item.name
            self.descLabel.text = item.desc
        }
    }
}


//MARK: - Setup view and contraints methods
private extension ItemDescriptionViewController {
    
    func setupViews() {
        view.addSubview(myImageView)
        view.addSubview(titleLabel)
        view.addSubview(descLabel)
    }
    
    func setupConstraints() {
        myImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(myImageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
            
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

