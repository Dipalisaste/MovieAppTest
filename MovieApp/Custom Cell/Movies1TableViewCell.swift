//
//  Movies1TableViewCell.swift
//  MovieApp
//
//
//

import UIKit

class Movies1TableViewCell: UITableViewCell {
    
    lazy var backView: UIView = {
        let view = UIView(frame: CGRect(x: 10, y: 6, width: (superview?.frame.width)! - 20 , height: 200))
        view.backgroundColor = UIColor.green
        return view
    }()

    lazy var movieImage: UIImageView = {
        let userImage = UIImageView(frame: CGRect(x: 7, y: 10, width: 150, height: 180))
    userImage.contentMode = .scaleAspectFit
        
        return userImage
        
    }()
    lazy var namelbl:UILabel = {
        let lbl = UILabel(frame: CGRect(x: 170, y: 0, width: backView.frame.width - 175, height: 80))
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        return lbl
        
    }()
    lazy var yearlbl:UILabel = {
        let lbl = UILabel(frame: CGRect(x: 170, y: 80, width: backView.frame.width - 180, height: 20))
        lbl.textAlignment = .left
        //lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.backgroundColor = .clear
        return lbl
        
    }()
    lazy var runtimelbl:UILabel = {
        let lbl = UILabel(frame: CGRect(x: 170, y: 100, width: backView.frame.width - 180, height: 20))
        lbl.textAlignment = .left
        lbl.backgroundColor = .clear
       // lbl.font = UIFont.boldSystemFont(ofSize: 20)
        
        
        return lbl
        
    }()
    lazy var castlbl:UILabel = {
        let lbl = UILabel(frame: CGRect(x: 170, y: 121, width: backView.frame.width - 175, height: 70))
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.backgroundColor = .clear
        //lbl.font = UIFont.boldSystemFont(ofSize: 18)
        
        return lbl
        
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        backView.layer.cornerRadius = 10
        backView.clipsToBounds = true
        movieImage.layer.cornerRadius = 20
        movieImage.backgroundColor = .clear
        movieImage.clipsToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        addSubview(backView)
        backView.addSubview(movieImage)
        backView.addSubview(namelbl)
        backView.addSubview(yearlbl)
        backView.addSubview(runtimelbl)
        backView.addSubview(castlbl)
    }

}
