//
//  ViewController.swift
//  catCrawler
//
//  Created by Mac pro on 2022/02/09.
//

import UIKit

class ViewController: UIViewController, CatViewModelOutput {
    
    
    
    private enum Metrics {
        static let inset : CGFloat = 4
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        layout.minimumLineSpacing = Metrics.inset
        layout.minimumInteritemSpacing = Metrics.inset
        return cv
    }()
    
    private let viewModel = CatViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView(){
        self.view.addSubview(self.collectionView)
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            
        ])
        
        self.collectionView.register(CatCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        self.viewModel.attach(delegate: self)
        self.viewModel.delegate = self
        self.viewModel.load()
    }
    
    func loadComplete() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }


}

extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        
        let cellWidth = (width - 2 * Metrics.inset ) / 3
        return  CGSize(width: cellWidth, height: cellWidth)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewModel.loadMoreIfNeeded(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(viewModel: self.viewModel, index: indexPath.item)
        self.present(detailViewController, animated: true, completion: nil)
    }
}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CatCell
        let data = self.viewModel.data[indexPath.item]
        cell.setupData(urlString: data.url)
        
        return cell
    }
    
    
}

