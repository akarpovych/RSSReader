//
//  NewsCell.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/2/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import UIKit


class NewsCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    weak var delegate: MainVCCellDelegate?
    
    @IBOutlet weak var descript: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func imageButtonPressed(_ sender: Any) {
        delegate?.imageButtonPressed(image: self.newsImage.image!)
    }
    
    func fillWith(model: NewsPosts, searchText: String) {
        guard let key = model.imageKey,
                let title = model.title,
                    let newsDescription = model.newsDescription else { return }
        self.newsImage?.image = ImageFetcher.retrieveImage(forKey: key)
        
        switch searchText.count {
        case 0:
            self.title.attributedText = NSMutableAttributedString(string: title)
            self.descript.attributedText =  NSMutableAttributedString(string: newsDescription)
        default:
            self.title.attributedText = boldSearchResult(searchString: searchText, resultString: title)
            self.descript.attributedText = boldSearchResult(searchString: searchText, resultString: newsDescription)
        }
    }
    
    func boldSearchResult(searchString: String, resultString: String) -> NSMutableAttributedString {
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: resultString)
        let pattern = searchString.lowercased()
        let range: NSRange = NSMakeRange(0, resultString.count)
        
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options())
        
        regex.enumerateMatches(in: resultString.lowercased(), options: NSRegularExpression.MatchingOptions(), range: range) { (textCheckingResult, matchingFlags, stop) -> Void in
            guard let subRange = textCheckingResult?.range else { return }
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 18.0), range: subRange)
        }
        
        return attributedString
        
    }
    
}
