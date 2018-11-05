//
//  JudoPayView.swift
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

open class JudoPayView: UIView {
    let transactionType: TransactionType
    let theme: Theme
    let cardDetails: CardDetails?
    let isTokenPayment: Bool

    let contentView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    let cardInputField: CardInputField
    let expiryDateInputField: DateInputField
    let secureCodeInputField: SecurityInputField
    let startDateInputField: DateInputField
    let issueNumberInputField: IssueNumberInputField
    let billingCountryInputField: BillingCountryInputField
    let postCodeInputField: PostCodeInputField
    let paymentButton: PayButton
    let loadingView: LoadingView
    let threeDSecureWebView = _DSWebView()
    let securityMessageLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var keyboardHeightConstraint: NSLayoutConstraint!
    var maestroFieldsHeightConstraint: NSLayoutConstraint!
    var avsFieldsHeightConstraint: NSLayoutConstraint!
    var securityMessageTopConstraint: NSLayoutConstraint!
    var paymentEnabled = false
    var currentKeyboardHeight: CGFloat = 0.0
    var paymentNavBarButton: UIBarButtonItem?

    public init(type: TransactionType, currentTheme: Theme, cardDetails: CardDetails? = nil, isTokenPayment: Bool = false) {
        transactionType = type
        theme = currentTheme
        self.cardDetails = cardDetails
        self.isTokenPayment = isTokenPayment

        cardInputField = CardInputField(theme: currentTheme)
        expiryDateInputField = DateInputField(theme: currentTheme)
        secureCodeInputField = SecurityInputField(theme: currentTheme)
        startDateInputField = DateInputField(theme: currentTheme)
        issueNumberInputField = IssueNumberInputField(theme: currentTheme)
        billingCountryInputField = BillingCountryInputField(theme: currentTheme)
        postCodeInputField = PostCodeInputField(theme: currentTheme)
        paymentButton = PayButton(currentTheme: currentTheme)
        loadingView = LoadingView(currentTheme: currentTheme)

        super.init(frame: UIScreen.main.bounds)

        setupView()

        NotificationCenter.default.addObserver(self, selector: #selector(JudoPayView.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JudoPayView.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ note: Notification) {
        guard let animationCurve = note.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
            let animationDuration = (note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue,
            let keyboardHeight = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        currentKeyboardHeight = keyboardHeight
        keyboardHeightConstraint.constant = -1 * keyboardHeight + (paymentEnabled ? 0 : paymentButton.bounds.height)
        paymentButton.setNeedsUpdateConstraints()

        UIView.animate(withDuration: animationDuration, delay: 0, options: UIView.AnimationOptions(rawValue: animationCurve), animations: {
            self.paymentButton.layoutIfNeeded()
        }, completion: nil)
    }

    @objc func keyboardWillHide(_ note: Notification) {
        guard let animationCurve = note.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
            let animationDuration = (note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { return }
        
        currentKeyboardHeight = 0.0
        keyboardHeightConstraint.constant = 0.0 + (paymentEnabled ? 0 : paymentButton.bounds.height)
        paymentButton.setNeedsUpdateConstraints()

        UIView.animate(withDuration: animationDuration, delay: 0, options: UIView.AnimationOptions(rawValue: animationCurve), animations: {
            self.paymentButton.layoutIfNeeded()
        }, completion: nil)
    }

    func setupView() {
        loadingView.actionLabel.text = transactionType == .registerCard ? theme.loadingIndicatorRegisterCardTitle : theme.loadingIndicatorProcessingTitle

        let attributedString = NSMutableAttributedString(string: "Secure server: ", attributes: [
            .foregroundColor: theme.getTextColor(),
            .font: UIFont.boldSystemFont(ofSize: theme.securityMessageTextSize)
            ])
        attributedString.append(NSAttributedString(string: theme.securityMessageString, attributes: [
            .foregroundColor: theme.getInputFieldHintTextColor(),
            .font: UIFont.systemFont(ofSize: theme.securityMessageTextSize)
            ]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 3
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        securityMessageLabel.attributedText = attributedString

        let payButtonTitle = transactionType == .registerCard ? theme.registerCardTitle : theme.paymentButtonTitle
        paymentButton.setTitle(payButtonTitle, for: .normal)

        startDateInputField.isStartDate = true

        backgroundColor = theme.getContentViewBackgroundColor()

        addSubview(contentView)
        contentView.contentSize = bounds.size
        contentView.addSubview(cardInputField)
        contentView.addSubview(expiryDateInputField)
        contentView.addSubview(secureCodeInputField)
        contentView.addSubview(startDateInputField)
        contentView.addSubview(issueNumberInputField)
        contentView.addSubview(billingCountryInputField)
        contentView.addSubview(postCodeInputField)
        contentView.addSubview(securityMessageLabel)
        addSubview(paymentButton)
        addSubview(threeDSecureWebView)
        addSubview(loadingView)

        cardInputField.delegate = self
        expiryDateInputField.delegate = self
        secureCodeInputField.delegate = self
        startDateInputField.delegate = self
        issueNumberInputField.delegate = self
        billingCountryInputField.delegate = self
        postCodeInputField.delegate = self

        let views: [String: Any] = [
            "scrollView": contentView,
            "paymentButton": paymentButton,
            "loadingView": loadingView,
            "card": cardInputField,
            "expiry": expiryDateInputField,
            "security": secureCodeInputField,
            "start": startDateInputField,
            "issue": issueNumberInputField,
            "billing": billingCountryInputField,
            "post": postCodeInputField,
            "securityMessage": securityMessageLabel,
            "tdsecure": threeDSecureWebView
        ]

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[scrollView]|", metrics: nil, views: views))

        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalToSystemSpacingBelow: safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
                safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: contentView.bottomAnchor, multiplier: 1.0)
                ])
        } else {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]-1-[paymentButton]", metrics: nil, views: views))
        }

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[loadingView]|", metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[loadingView]|", metrics: nil, views: views))

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-[tdsecure]-|", metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(68)-[tdsecure]-(30)-|", metrics: nil, views: views))

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[paymentButton]|", metrics: nil, views: views))
        paymentButton.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50))

        keyboardHeightConstraint = NSLayoutConstraint(item: paymentButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: paymentEnabled ? 0 : 50)
        addConstraint(keyboardHeightConstraint)

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(-1)-[card]-(-1)-|", metrics: nil, views: views))
        contentView.addConstraint(NSLayoutConstraint(item: cardInputField, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1, constant: 2))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(-1)-[expiry]-(-1)-[security(==expiry)]-(-1)-|", metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(-1)-[start]-(-1)-[issue(==start)]-(-1)-|", metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(-1)-[billing]-(-1)-[post(==billing)]-(-1)-|", metrics: nil, views: views))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(12)-[securityMessage]-(12)-|", metrics: nil, views: views))

        let metrics: [String: Any] = [
            "fieldHeight": theme.inputFieldHeight,
            "spacing": 10
        ]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-75-[card(fieldHeight)]-(spacing)-[start]-(spacing)-[expiry(fieldHeight)]-(spacing)-[billing]-(20)-|", metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-75-[card(fieldHeight)]-(spacing)-[issue(==start)]-(spacing)-[security(fieldHeight)]-(spacing)-[post(==billing)]-(20)-|", metrics: metrics, views: views))

        maestroFieldsHeightConstraint = NSLayoutConstraint(item: startDateInputField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
        avsFieldsHeightConstraint = NSLayoutConstraint(item: billingCountryInputField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
        securityMessageTopConstraint = NSLayoutConstraint(item: securityMessageLabel, attribute: .top, relatedBy: .equal, toItem: postCodeInputField, attribute: .bottom, multiplier: 1.0, constant: 8.0)

        securityMessageLabel.isHidden = !theme.showSecurityMessage

        startDateInputField.addConstraint(maestroFieldsHeightConstraint!)
        billingCountryInputField.addConstraint(avsFieldsHeightConstraint!)
        contentView.addConstraint(securityMessageTopConstraint!)

        // If card details are available, fill out the fields
        if let cardDetails = cardDetails, let formattedLastFour = cardDetails.formattedLastFour(), let expiryDate = cardDetails.formattedEndDate() {
            updateInputFieldsWithNetwork(cardDetails.cardNetwork)
            if !isTokenPayment, let presentationCardNumber = try? cardDetails._cardNumber?.cardPresentationString(theme.acceptedCardNetworks) {
                cardInputField.textField.text = presentationCardNumber
                cardInputField.textField.alpha = 1.0
                expiryDateInputField.textField.alpha = 1.0
            } else {
                cardInputField.textField.text = formattedLastFour
            }

            cardInputField.isTokenPayment = isTokenPayment
            cardInputField.isUserInteractionEnabled = !isTokenPayment
            cardInputField.textField.isSecureTextEntry = false
            expiryDateInputField.textField.text = expiryDate
            expiryDateInputField.isUserInteractionEnabled = !isTokenPayment
            secureCodeInputField.isTokenPayment = isTokenPayment
            updateInputFieldsWithNetwork(cardDetails.cardNetwork)
        }
    }

    /**
     This method is intended to toggle the start date and issue number fields visibility when a Card has been identified.

     - Discussion: Maestro cards need a start date or an issue number to be entered for making any transaction

     - parameter isVisible: Whether start date and issue number fields should be visible
     */
    open func toggleStartDateVisibility(_ isVisible: Bool) {
        maestroFieldsHeightConstraint?.constant = isVisible ? theme.inputFieldHeight : 0
        issueNumberInputField.setNeedsUpdateConstraints()
        startDateInputField.setNeedsUpdateConstraints()
        startDateInputField.isVisible = isVisible
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.issueNumberInputField.layoutIfNeeded()
            self.startDateInputField.layoutIfNeeded()
            self.expiryDateInputField.layoutIfNeeded()
            self.secureCodeInputField.layoutIfNeeded()
        }, completion: nil)
    }

    /**
     This method toggles the visibility of address fields (billing country and post code).

     - Discussion: If AVS is necessary, this should be activated. AVS only needs Postcode to verify

     - parameter isVisible:  Whether post code and billing country fields should be visible
     - parameter completion: Block that is called when animation was finished
     */
    open func toggleAVSVisibility(_ isVisible: Bool, completion: ((Bool) -> Void)? = nil) {
        avsFieldsHeightConstraint?.constant = isVisible ? theme.inputFieldHeight : 0
        billingCountryInputField.setNeedsUpdateConstraints()
        postCodeInputField.setNeedsUpdateConstraints()

        //Trigger constraint update for Start date for maestro cards to recalculate space
        if isVisible {
            startDateInputField.displayHint(message: "")
        }

        UIView.animate(withDuration: 0.2, animations: {
            self.billingCountryInputField.layoutIfNeeded()
            self.postCodeInputField.layoutIfNeeded()
        }, completion: completion)
    }

    /**
     When a network has been identified, the secure code text field has to adjust its title and maximum number entry to enable the payment

     - parameter network: The network that has been identified
     */
    func updateInputFieldsWithNetwork(_ network: CardNetwork?) {
        guard let network = network else { return }

        cardInputField.cardNetwork = network
        cardInputField.updateCardLogo()
        secureCodeInputField.cardNetwork = network
        secureCodeInputField.updateCardLogo()
        secureCodeInputField.textField.placeholder = network.securityCodeTitle()
        toggleStartDateVisibility(network == .maestro)
    }

    /**
     Helper method to enable the payment after all fields have been validated and entered

     - parameter enabled: Pass true to enable the payment buttons
     */
    func paymentEnabled(_ enabled: Bool) {
        paymentEnabled = enabled
        paymentButton.isHidden = !enabled

        keyboardHeightConstraint.constant = -currentKeyboardHeight + (paymentEnabled ? 0 : paymentButton.bounds.height)
        paymentButton.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: enabled ? .curveEaseOut : .curveEaseIn, animations: {
            self.paymentButton.layoutIfNeeded()
        }, completion: nil)

        if enabled {
            paymentNavBarButton?.setTitleTextAttributes([.foregroundColor: theme.tintActiveColor], for: .normal)
        }
        paymentNavBarButton?.isEnabled = enabled
    }

    /**
     The hint label has a timer that executes the visibility.

     - parameter input: The input field which the user is currently idling
     */
    func showHintAfterDefaultDelay(_ input: JudoPayInputField) {
        if secureCodeInputField.isTokenPayment && secureCodeInputField.textField.text?.count == 0 {
            input.displayHint(message: secureCodeInputField.hintLabelText())
        } else {
            input.displayHint(message: "")
            cardInputField.displayHint(message: "")
            expiryDateInputField.displayHint(message: "")
            if startDateInputField.isVisible {
                startDateInputField.displayHint(message: "")
            }
            updateViews(input: input, isFirstRun: true)
        }
        updateSecurityMessagePosition(toggleUp: true)
        _ = Timer.schedule(5.0, handler: { (timer) -> Void in
            let hintLabelText = input.hintLabelText()
            if hintLabelText.count > 0
                && input.textField.text?.count == 0
                && input.textField.isFirstResponder {
                self.updateSecurityMessagePosition(toggleUp: false)
                input.displayHint(message: input.hintLabelText())
                self.updateViews(input: input, isFirstRun: false)
            }
        })
    }

    /**
     Helper method to update the position of the security message

     - parameter toggleUp: whether the label should move up or down
     */
    func updateSecurityMessagePosition(toggleUp: Bool) {
        contentView.layoutIfNeeded()
        securityMessageTopConstraint.constant = toggleUp ? 8 : 24
        UIView.animate(withDuration: 0.3, animations: { self.contentView.layoutIfNeeded() })
    }

    func updateViews(input: JudoPayInputField, isFirstRun: Bool) {
        //Just trigger first view constraint in Horizontal view
        if input.isKind(of: SecurityInputField.self) {
            expiryDateInputField.displayHint(message: (expiryDateInputField.textField.text?.count)! > 0 ? (secureCodeInputField.textField.text?.count)! > 0 ? "": isFirstRun ? "" : " " : isFirstRun ? "" : " ")
        }
        if input.isKind(of: IssueNumberInputField.self) {
            startDateInputField.displayHint(message: (startDateInputField.textField.text?.count)! > 0 ? (issueNumberInputField.textField.text?.count)! > 0 ? "": isFirstRun ? "" : " " : isFirstRun ? "" : " ")
        }
    }
}
