//
//  InformationVC.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/2/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import UIKit

protocol InformationVCDelegate: class {
    func openInWeb(url: String)
}

class InformationVC: UIViewController, StoryboardLoadable {
    var news: NewsPosts?
    var delegate: InformationVCDelegate?
    
    @IBOutlet weak var generalInfo: UILabel!
    @IBOutlet weak var descriptLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var descriptValue: UILabel!
    @IBOutlet weak var titleValue: UILabel!
    @IBOutlet weak var dateValue: UILabel!
    
    @IBOutlet weak var openInWebButton: UIButton!
    
    @IBAction func openInWebPressed(_ sender: Any) {
        guard let link = news?.link else { return }
        self.delegate?.openInWeb(url: link)
    }
    
    static func makeViewController(delegate: InformationVCDelegate, news: NewsPosts) -> InformationVC {
        let vc = loadFromStoryboard()
        vc.news = news
        vc.delegate = delegate
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        guard let news = self.news else { return }
        self.setupText(news: news)
    }
    
    func setupText(news: NewsPosts) {
        self.generalInfo.text = LString.GENERAL_INFO.TITLE
        self.descriptLabel.text = LString.DESCRIPTION.TITLE
        self.titleLabel.text = LString.TITLE.TITLE
        self.dateLabel.text = LString.DATE.TITLE
        self.openInWebButton.setTitle(LString.OPEN_IN_WEB.TITLE, for: .normal)
        
        self.descriptValue.text = news.newsDescription
        self.titleValue.text = news.title
        self.dateValue.text = news.date
        
    }

}
