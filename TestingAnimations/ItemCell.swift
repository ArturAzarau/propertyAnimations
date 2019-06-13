//
//  ItemCell.swift
//  TestingAnimations
//
//  Created by Артур Азаров on 13/06/2019.
//  Copyright © 2019 Артур Азаров. All rights reserved.
//

import UIKit

final class ItemCell: UICollectionViewCell {

    var firstLabel = UILabel()
    var secondLabel = UILabel()


    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        configureAppearance()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        contentView.addSubview(firstLabel)
        contentView.addSubview(secondLabel)
    }

    private func configureAppearance() {
        firstLabel.layer.anchorPoint = .init(x: 0, y: 0)
        firstLabel.font = .systemFont(ofSize: 36)
        firstLabel.text = "first"
        firstLabel.textColor = .white

        secondLabel.textColor = .white
        secondLabel.text = "second"
        contentView.backgroundColor = .black
    }

    private func configureLayout() {
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15 - firstLabel.intrinsicContentSize.width / 2),
            firstLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 20),
            secondLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        ])
    }
}
