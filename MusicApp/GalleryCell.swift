//
//  GalleryCell.swift
//  MusicApp
//
//  Created by Dara Adekore on 2023-02-15.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    private var albumImageView = UIImageView()
    private var titleLabel = UILabel()
    private var artistLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumImageView.image = nil
        titleLabel.text = ""
        artistLabel.text = ""
        albumImageView.backgroundColor = .gray
    }
    
    private func configureSubviews() {
        // Add subviews to the cell's contentView
        contentView.addSubview(albumImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(artistLabel)
        
        // Configure subview properties
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        albumImageView.contentMode = .scaleAspectFill
        albumImageView.backgroundColor = .gray
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.textColor = .white
        artistLabel.font = UIFont.systemFont(ofSize: 14)
        artistLabel.textAlignment = .center
        
        // Add autolayout constraints to position and size subviews
        NSLayoutConstraint.activate([
            albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            albumImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            albumImageView.bottomAnchor.constraint(equalTo: artistLabel.topAnchor, constant: -8),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: artistLabel.topAnchor, constant: -8),
            
            artistLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artistLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with track: Track) {
        if let imageSrc = track.artworkUrl100{
            if let url = URL(string: imageSrc){
                NetworkManager.shared.request(url: url, completion: { result in
                    switch result{
                    case .success(let data):
                        DispatchQueue.main.async {
                            self.albumImageView.image = UIImage(data: data)
                        }
                    case .failure(let error):
                        print(error)
                    }
                })
            }
        }        
        DispatchQueue.main.async {
            self.titleLabel.text = track.trackName
            self.artistLabel.text = track.artistName
        }
    }
}
