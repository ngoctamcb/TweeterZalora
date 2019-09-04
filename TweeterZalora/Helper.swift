//
//  Helper.swift
//  TweeterZalora
//
//  Created by Tran Ngoc Tam on 9/4/19.
//  Copyright © 2019 Tran Ngoc Tam. All rights reserved.
//

import Foundation

class Helper {
    
    static func tweet(messageInput: String, limit: Int) -> [String] {
        
        let error = "The message contains a span of non-whitespace characters longer than \(limit) characters"
        
        let message = messageInput.condensedWhitespace
        
        guard message.count > limit else { return [message] }
        
        let calculateTotal: Int = (message.count / limit) + (message.count % limit > 0 ? 1 : 0)
        
        let words = message.components(separatedBy: .whitespacesAndNewlines)
        
        let errorWords = words.filter { return $0.count > limit }
        
        guard errorWords.count <= 0 else { return [error] }
        
        return joinedPartial(words, calculateTotal: calculateTotal, limit: limit)
    }
    
    static func joinedPartial(_ words: [String], calculateTotal: Int, limit: Int) -> [String] {
        
        var results: [String] = []
        var breakAtIndex = -1
        
        for i in 0..<calculateTotal {
            
            var partial = "\(i + 1)/\(calculateTotal) "
            let indicatorLength = partial.count
            var length = partial.count
            
            for (index, item) in words.enumerated() {
                
                guard item.count + indicatorLength <= limit else { return [] }
                
                guard index > breakAtIndex else { continue }
                
                length += item.count + 1
                
                guard length <= limit + 1 else { break }
                
                partial += item + " "
                
                breakAtIndex = index
            }
            
            results.append(partial.trimmingCharacters(in: .whitespaces))
        }
        
        if breakAtIndex < words.count - 1 {
            let total = calculateTotal + 1
            results = joinedPartial(words, calculateTotal: total, limit: limit)
        }
        
        return results
    }
}

extension String {
    
    var condensedWhitespace: String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
