//
//  NetworkWorker.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/2/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//


import Foundation

public class News {
    var title: String = String()
    var date: String = String()
    var newsDescription: String = String()
    var link: String = String()
    var imageUrl:String = String()
}

class XmlParserManager: NSObject, XMLParserDelegate {
    var news: [News] = [News]()
    var element: String = String()
    var foundNews: News?
    var data: Data?
    
    init(data: Data) {
        self.data = data
    }
    
    func start(completionBlock: (([News]) -> Void)?) {
        guard let data = self.data else { return }
        let parser = XMLParser(data: data)
            parser.delegate = self
            parser.shouldProcessNamespaces = false
            parser.shouldReportNamespacePrefixes = false
            parser.shouldResolveExternalEntities = false
        if parser.parse() {
            completionBlock?(self.news)
        }
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "item" {
            self.foundNews = News()
        } else if elementName == "enclosure" {
            if let urlString = attributeDict["url"] {
                self.foundNews?.imageUrl = urlString
            }
        }
        
        self.element = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if let found = self.foundNews {
                self.news.append(found)
                self.foundNews = nil
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if !data.isEmpty {
            switch self.element {
            case "title":
                self.foundNews?.title = string
            case "link":
                self.foundNews?.link = string
            case "description":
                self.foundNews?.newsDescription = string
            case "pubDate":
                self.foundNews?.date = string
            default: break
            }
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
        element = ""
        foundNews = nil
    }
}
