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
open class _DSWebView: UIWebView {
    
    // MARK: initialization
    
    /**
    Designated initializer
    
    - returns: a 3DSWebView object
    */
    public init() {
        super.init(frame: CGRect.zero)
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
    open func setupView() {
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
    open func load3DSWithPayload(_ payload: [String : AnyObject]) throws -> String {
        let allowedCharacterSet = CharacterSet(charactersIn: ":/=,!$&'()*+;[]@#?").inverted
        
        guard let urlString = payload["acsUrl"] as? String,
            let acsURL = URL(string: urlString),
            let md = payload["md"],
            let receiptId = payload["receiptId"] as? String,
            let paReqString = payload["paReq"],
            let paReqEscapedString = paReqString.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet),
            //This is not a real endpoint and isn't called. A guide on 3DS will be publised soon.
            let termURLString = "https://pay.judopay.com/iOS/Parse3DS".addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) else {
                throw JudoError(.failed3DSError)
        }
        
        if let postData = "MD=\(md)&PaReq=\(paReqEscapedString)&TermUrl=\(termURLString)".data(using: String.Encoding.utf8) {
            let request = NSMutableURLRequest(url: acsURL)
            request.httpMethod = "POST"
            request.setValue("\(postData.count)", forHTTPHeaderField: "Content-Length")
            request.httpBody = postData
            
            self.loadRequest(request as URLRequest)
        } else {
            throw JudoError(.failed3DSError)
        }
        
        return receiptId // save it for later
    }
    
}
