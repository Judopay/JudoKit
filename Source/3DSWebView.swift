//
//  3DSWebView.swift
//  JudoKit
//
//  Created by Hamon Riazy on 22/09/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit
import Judo

public class _DSWebView: UIWebView {
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alpha = 0.0
    }
    
    // MARK: configuration
    
    public func load3DSWithPayload(payload: [String : AnyObject]) throws -> String {
        let allowedCharacterSet = NSCharacterSet(charactersInString: ":/=,!$&'()*+;[]@#?").invertedSet
        
        guard let urlString = payload["acsUrl"] as? String,
            let acsURL = NSURL(string: urlString),
            let md = payload["md"],
            let receiptID = payload["receiptId"] as? String,
            let paReqString = payload["paReq"],
            let paReqEscapedString = paReqString.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet),
            let termURLString = "judo1234567890://threedsecurecallback".stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) else {
                throw JudoError.Failed3DSError
        }
        
        if let postData = "MD=\(md)&PaReq=\(paReqEscapedString)&TermUrl=\(termURLString)".dataUsingEncoding(NSUTF8StringEncoding) {
            let request = NSMutableURLRequest(URL: acsURL)
            request.HTTPMethod = "POST"
            request.setValue("\(postData.length)", forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postData
            
            self.loadRequest(request)
        } else {
            throw JudoError.Failed3DSError
        }
        
        return receiptID // save it for later
    }
    
}
