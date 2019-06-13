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
    var progressWhenInterrupted: CGFloat = 0
    var inProgress = false
    var shouldAbs = false
    var transform: CGAffineTransform?
    var newLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()

        layout.itemSize = CGSize(width: 300, height: 200)
        layout.scrollDirection = .horizontal
        return layout
    }()

    let firstFont = UIFont.systemFont(ofSize: 12)
    let secondFont = UIFont.systemFont(ofSize: 36)

    var scale: CGFloat {
        return firstFont.pointSize / secondFont.pointSize
    }

    var reverseScale: CGFloat {
        return 1 / scale
    }

    var firstLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()

        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: firstLayout)
        collectionView.dataSource = self
        collectionView.backgroundColor = .darkGray
//        collectionView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        view.addSubview(collectionView)
        configureCollectionViewLayout()

        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanRecognizer(_:)))
        rectView.addGestureRecognizer(recognizer)

        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: "itemCell")
    }

    @objc
    private func handlePanRecognizer(_ recognizer: UIPanGestureRecognizer) {
        if transform == nil {
            let cells = collectionView.visibleCells
            if let cell = cells.first {
                transform = cell.transform
            }
        }
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: rectView)
            let cells = collectionView.visibleCells as! [ItemCell]
            if !inProgress {
//                cells.forEach { $0.firstLabel.layer.anchorPoint = .init(x: 0, y: 0) }
                animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: { [rectView] in
                    if translation.y > 0 {
                        self.inProgress = true
                        rectView!.frame = rectView!.frame.offsetBy(dx: 0, dy: 30)
                        cells.forEach {
                            $0.frame.size = $0.frame.size.applying(.init(scaleX: 1, y: 2.5))
                            $0.secondLabel.alpha = 1
//                            $0.firstLabel.frame.size = $0.firstLabel.frame.size.applying(.init(scaleX: self.reverseScale,
//                                                                                               y: self.reverseScale))
                            $0.firstLabel.transform = .identity
                        }
                    } else {
                        self.shouldAbs = true
                        self.inProgress = true
                        rectView!.frame = rectView!.frame.offsetBy(dx: 0, dy: -30)
                        cells.forEach {
                            $0.frame.size = $0.frame.size.applying(.init(scaleX: 1, y: 0.4))
                            $0.secondLabel.alpha = 0
                            $0.firstLabel.transform = CGAffineTransform(scaleX: self.scale,
                                                                        y: self.scale)
//                            $0.firstLabel.frame.size = $0.firstLabel.frame.size.applying(.init(scaleX: self.scale,
//                                                                                               y: self.scale))
                        }
                    }
                })

                animator?.startAnimation()

            }
            animator?.pauseAnimation()
            if shouldAbs {
                if translation.y <= rectView.frame.height / 2 {
                    animator?.fractionComplete = abs(translation.y) / 30
                }
            } else {
                animator?.fractionComplete = translation.y / 30
            }

        case .ended:
            animator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            shouldAbs = false
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
        return collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath)
    }


}
