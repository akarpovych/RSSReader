//
//  NewsRepository.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/2/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import Foundation
import UIKit

class NewsRepository {

    let url = URL(string: "http://feeds.skynews.com/feeds/rss/technology.xml")!
    
    func start(completionBlock: (([NewsPosts]) -> Void)? = nil) {
        self.downloadNewsFromAPI() { news in
            if news.isEmpty {
                guard let allNewsPosts = NewsPosts.all() else { return }
                completionBlock?(allNewsPosts)
            } else {
                self.saveNewsToDatabase(news: news) { result in
                    completionBlock?(result)
                }
            }
        }
    }
    
    func downloadNewsFromAPI(completionBlock: (([News]) -> Void)?) {
        let emptyNews: [News] = [News]()
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                completionBlock?(emptyNews)
                return
            }
            let parser = XmlParserManager(data: data)
            parser.start() { news in
                completionBlock?(news)
            }
        }
        task.resume()
    }
    
    func convertDateStringToDate(string: String) -> Date? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterGet.dateFormat = "E, d MMM yyyy HH:mm:ss Z"

        return dateFormatterGet.date(from: string)
    }
    
    func saveNewsToDatabase(news: [News], completionBlock: (([NewsPosts]) -> Void)? = nil) {
        DatabaseManager.shared.save({
            for newOne in news {
                let alreadyExist = NewsPosts.all()?.filter { $0.link == newOne.link }.first
                if alreadyExist == nil {
                    guard let entity = NewsPosts.createEntity() else { return }
                    entity.title = newOne.title
                    entity.date = newOne.date
                    entity.link = newOne.link
                    entity.newsDescription = newOne.newsDescription
                    entity.imageKey = newOne.imageUrl
                    entity.dateFormatted = self.convertDateStringToDate(string: newOne.date)
                }
            }
            
        },completion: { status in
            guard let allNewsPosts = NewsPosts.all() else { return }
            var sortedNews = allNewsPosts
            
            sortedNews.sort() { guard let dateZero = $0.dateFormatted, let dateOne = $1.dateFormatted else { return false }
                return dateZero > dateOne }
            
            ImageFetcher.savePhotos(news: sortedNews) { status in
                completionBlock?(sortedNews)
            }
        })
    }
}
