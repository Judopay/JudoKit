//
//  3DSWebView.swift
//  JudoKit
//
//  Copyright (c) 2016 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit


/**
 
 The 3DSWebView is a UIWebView subclass that is configured to detect the execution of a 3DS validation page.
 
 */
public class _DSWebView: UIWebView {
    
    // MARK: initialization
    
    /**
    Designated initializer
    
    - returns: a 3DSWebView object
    */
    public init() {
        super.init(frame: CGRectZero)
        self.setupView()
    }
    
    
    /**
     Convenience initializer
     
     - parameter frame: ignored
     
     - returns: a 3DSWebView object
     */
    convenience override init(frame: CGRect) {
        self.init()
    }
    
    
    /**
     Convenience initializer
     
     - parameter aDecoder: ignored
     
     - returns: a 3DSWebView object
     */
    convenience required public init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    // MARK: View Setup
    
    /**
    Helper method to setup the view
    */
    public func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alpha = 0.0
    }
    
    // MARK: configuration
    
    /**
    This method initiates the webview to load the 3DS website.
    
    - parameter payload: the payload that contains the 3DS information to be loaded
    
    - throws: `Failed3DSError` when payload contains faulty information
    
    - returns: the receiptId of the transaction
    */
    public func load3DSWithPayload(payload: [String : AnyObject]) throws -> String {
        let allowedCharacterSet = NSCharacterSet(charactersInString: ":/=,!$&'()*+;[]@#?").invertedSet
        
        guard let urlString = payload["acsUrl"] as? String,
            let acsURL = NSURL(string: urlString),
            let md = payload["md"],
            let receiptId = payload["receiptId"] as? String,
            let paReqString = payload["paReq"],
            let paReqEscapedString = paReqString.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet),
            let termURLString = "https://pay.judopay.com/iOS/Parse3DS".stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) else {
                throw JudoError(.Failed3DSError)
        }
        
        if let postData = "MD=\(md)&PaReq=\(paReqEscapedString)&TermUrl=\(termURLString)".dataUsingEncoding(NSUTF8StringEncoding) {
            let request = NSMutableURLRequest(URL: acsURL)
            request.HTTPMethod = "POST"
            request.setValue("\(postData.length)", forHTTPHeaderField: "Content-Length")
            request.HTTPBody = postData
            
            self.loadRequest(request)
        } else {
            throw JudoError(.Failed3DSError)
        }
        
        return receiptId // save it for later
    }
    
}
