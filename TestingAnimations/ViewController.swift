//
//  ViewController.swift
//  TestingAnimations
//
//  Created by Артур Азаров on 13/06/2019.
//  Copyright © 2019 Артур Азаров. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var rectView: UIView!

    var collectionView: UICollectionView!
    var animator: UIViewPropertyAnimator?

    var scale: CGFloat {
        let firstFont = UIFont.systemFont(ofSize: 12)
        let secondFont = UIFont.systemFont(ofSize: 36)
        return firstFont.pointSize / secondFont.pointSize
    }

    var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()

        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        return layout
    }()

    var expandedHeight: CGFloat = 100
    var shrinkedHeight: CGFloat = 40

    func identityTransform(cell: ItemCell) {
        cell.frame.size.height = expandedHeight
        cell.secondLabel.alpha = 1
        cell.firstLabel.transform = .identity
    }

    func transform(cell: ItemCell) {
        cell.secondLabel.alpha = 0
        cell.firstLabel.transform = CGAffineTransform(scaleX: self.scale,
                                                    y: self.scale)
        cell.frame.size.height = shrinkedHeight
    }

//    var shouldResizeArray = Array(repeating: false, count: 10)

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .darkGray
        view.addSubview(collectionView)
        configureCollectionViewLayout()

        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanRecognizer(_:)))
        rectView.addGestureRecognizer(recognizer)

        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: "itemCell")
    }

    var inProgress = false

    @objc
    private func handlePanRecognizer(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: rectView)
            let cells = collectionView.visibleCells as! [ItemCell]
            let shouldChangeStateToExpanded = translation.y > 0

            if !inProgress {
                animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: { [rectView] in
                    if shouldChangeStateToExpanded {
                        rectView!.frame = rectView!.frame.offsetBy(dx: 0, dy: 70)
                        cells.forEach {
                            self.identityTransform(cell: $0)
                        }
                        ItemCell.state = .expanded
                    } else {
                        rectView!.frame = rectView!.frame.offsetBy(dx: 0, dy: -70)
                        cells.forEach {
                            self.transform(cell: $0)
                        }
                        ItemCell.state = .shrinked
                    }
                })
                inProgress = true
                animator?.startAnimation()
            }
            animator?.pauseAnimation()
            animator?.fractionComplete = translation.y / 70
        case .ended:
            animator?.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            inProgress = false
        default:
            break
        }
    }

    private func configureCollectionViewLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCell
        cell.firstLabel.text = "\(indexPath.row)"
        cell.secondLabel.text = "\(indexPath.row)"
        return cell
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch ItemCell.state {
        case .expanded:
            identityTransform(cell: cell as! ItemCell)
        case .shrinked:
            transform(cell: cell as! ItemCell)
        }
    }
}
