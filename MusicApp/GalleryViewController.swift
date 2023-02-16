//
//  ViewController.swift
//  MusicApp
//
//  Created by Dara Adekore on 2023-02-15.
//

import UIKit

class GalleryViewController: UIViewController {
    var tracks = [Track]()
    let searchBar = UISearchBar()
    var galleryCollectionView:UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        galleryCollectionView = UICollectionView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100), collectionViewLayout: layout)
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        galleryCollectionView.register(GalleryCell.self, forCellWithReuseIdentifier: "gallery")
        //Looks for single or multiple taps.
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        view.addSubview(searchBar)
        view.addSubview(galleryCollectionView)
    }
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        searchBar.endEditing(true)
    }
    override func viewDidLayoutSubviews() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
extension GalleryViewController : UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryCollectionView.dequeueReusableCell(withReuseIdentifier: "gallery", for: indexPath) as? GalleryCell
        cell?.configure(with: tracks[indexPath.item])
        return cell!
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            // scroll to the end of the collection view
            let indexPath = IndexPath(item: tracks.count - 1, section: 0)
            galleryCollectionView.scrollToItem(at: indexPath, at: .right, animated: false)
        } else if scrollView.contentOffset.x == scrollView.contentSize.width - scrollView.frame.width {
            // scroll to the beginning of the collection view
            let indexPath = IndexPath(item: 0, section: 0)
            galleryCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchBar.text != "" else { return }
        guard let url = URL(string: NetworkManager.shared.makeUrl(searchBar.text ?? "")) else { return }
        NetworkManager.shared.request(url: url, completion: { result in
            switch result {
            case .success(let data):
                do{
                    guard let jsonString = String(data: data, encoding: .utf8) else {
                        // handle invalid encoding
                        return
                    }
                    
                    //print(jsonString)
                    guard let jsonData = jsonString.data(using: .utf8) else {
                        // handle invalid encoding
                        return
                    }
                    //print(jsonData)
                    let jsonDecoder = JSONDecoder()
                    let searchData = try jsonDecoder.decode(TrackResponse.self, from: jsonData)
                    self.tracks = searchData.results
                    DispatchQueue.main.async {
                        self.galleryCollectionView.reloadData()
                    }
                }catch{
                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                print(error)
            }
        })
        searchBar.endEditing(true)
    }
}

