//
//  JudoErrorCode.swift
//  Judo
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

import Foundation


/**
 A mirror of the backend error set
 
 - General_Error:                                         General_Error
 - General_Model_Error:                                   General_Model_Error
 - Unauthorized:                                          Unauthorized
 - Payment_System_Error:                                  Payment_System_Error
 - Payment_Declined:                                      Payment_Declined
 - Payment_Failed:                                        Payment_Failed
 - Transaction_Not_Found:                                 Transaction_Not_Found
 - Validation_Passed:                                     Validation_Passed
 - Uncaught_Error:                                        Uncaught_Error
 - Server_Error:                                          Server_Error
 - Invalid_From_Date:                                     Invalid_From_Date
 - Invalid_To_Date:                                       Invalid_To_Date
 - CantFindWebPayment:                                    CantFindWebPayment
 - General_Error_Simple_Application:                      General_Error_Simple_Application
 - InvalidApiVersion:                                     InvalidApiVersion
 - MissingApiVersion:                                     MissingApiVersion
 - PreAuthExpired:                                        PreAuthExpired
 - Collection_Original_Transaction_Wrong_Type:            Collection_Original_Transaction_Wrong_Type
 - Currency_Must_Equal_Original_Transaction:              Currency_Must_Equal_Original_Transaction
 - Cannot_Collect_A_Voided_Transaction:                   Cannot_Collect_A_Voided_Transaction
 - Collection_Exceeds_PreAuth:                            Collection_Exceeds_PreAuth
 - Refund_Original_Transaction_Wrong_Type:                Refund_Original_Transaction_Wrong_Type
 - Cannot_Refund_A_Voided_Transaction:                    Cannot_Refund_A_Voided_Transaction
 - Refund_Exceeds_Original_Transaction:                   Refund_Exceeds_Original_Transaction
 - Void_Original_Transaction_Wrong_Type:                  Void_Original_Transaction_Wrong_Type
 - Void_Original_Transaction_Is_Already_Void:             Void_Original_Transaction_Is_Already_Void
 - Void_Original_Transaction_Has_Been_Collected:          Void_Original_Transaction_Has_Been_Collected
 - Void_Original_Transaction_Amount_Not_Equal_To_Preauth: Void_Original_Transaction_Amount_Not_Equal_To_Preauth
 - UnableToAccept:                                        UnableToAccept
 - AccountLocationNotFound:                               AccountLocationNotFound
 - AccessDeniedToTransaction:                             AccessDeniedToTransaction
 - NoConsumerForTransaction:                              NoConsumerForTransaction
 - TransactionNotEnrolledInThreeDSecure:                  TransactionNotEnrolledInThreeDSecure
 - TransactionAlreadyAuthorizedByThreeDSecure:            TransactionAlreadyAuthorizedByThreeDSecure
 - ThreeDSecureNotSuccessful:                             ThreeDSecureNotSuccessful
 - ApUnableToDecrypt:                                     ApUnableToDecrypt
 - ReferencedTransactionNotFound:                         ReferencedTransactionNotFound
 - ReferencedTransactionNotSuccessful:                    ReferencedTransactionNotSuccessful
 - TestCardNotAllowed:                                    TestCardNotAllowed
 - Collection_Not_Valid:                                  Collection_Not_Valid
 - Refund_Original_Transaction_Null:                      Refund_Original_Transaction_Null
 - Refund_Not_Valid:                                      Refund_Not_Valid
 - Void_Not_Valid:                                        Void_Not_Valid
 - Unknown:                                               Unknown
 - CardTokenInvalid:                                      CardTokenInvalid
 - UnknownPaymentModel:                                   UnknownPaymentModel
 - UnableToRouteTransaction:                              UnableToRouteTransaction
 - CardTypeNotSupported:                                  CardTypeNotSupported
 - CardCv2Invalid:                                        CardCv2Invalid
 - CardTokenDoesntMatchConsumer:                          CardTokenDoesntMatchConsumer
 - WebPaymentReferenceInvalid:                            WebPaymentReferenceInvalid
 - WebPaymentAccountLocationNotFound:                     WebPaymentAccountLocationNotFound
 - RegisterCardWithWrongTransactionType:                  RegisterCardWithWrongTransactionType
 - InvalidAmountToRegisterCard:                           InvalidAmountToRegisterCard
 - ContentTypeNotSpecifiedOrUnsupported:                  ContentTypeNotSpecifiedOrUnsupported
 - InternalErrorAuthenticating:                           InternalErrorAuthenticating
 - TransactionNotFound:                                   TransactionNotFound
 - ResourceNotFound:                                      ResourceNotFound
 - LackOfPermissionsUnauthorized:                         LackOfPermissionsUnauthorized
 - ContentTypeNotSupported:                               ContentTypeNotSupported
 - AuthenticationFailure:                                 AuthenticationFailure
 - Not_Found:                                             Not_Found
 - MustProcessPreAuthByToken:                             MustProcessPreAuthByToken
 - ApplicationModelIsNull:                                ApplicationModelIsNull
 - ApplicationModelRequiresReference:                     ApplicationModelRequiresReference
 - ApplicationHasAlreadyGoneLive:                         ApplicationHasAlreadyGoneLive
 - MissingProductSelection:                               MissingProductSelection
 - AccountNotInSandbox:                                   AccountNotInSandbox
 - ApplicationRecIdRequired:                              ApplicationRecIdRequired
 - RequestNotProperlyFormatted:                           RequestNotProperlyFormatted
 - NoApplicationReferenceFound:                           NoApplicationReferenceFound
 - NotSupportedFileType:                                  NotSupportedFileType
 - ErrorWithFileUpload:                                   ErrorWithFileUpload
 - EmptyApplicationReference:                             EmptyApplicationReference
 - ApplicationDoesNotExist:                               ApplicationDoesNotExist
 - UnknownSortSpecified:                                  UnknownSortSpecified
 - PageSizeLessThanOne:                                   PageSizeLessThanOne
 - PageSizeMoreThanFiveHundred:                           PageSizeMoreThanFiveHundred
 - OffsetLessThanZero:                                    OffsetLessThanZero
 - InvalidMerchantId:                                     InvalidMerchantId
 - MerchantIdNotFound:                                    MerchantIdNotFound
 - NoProductsWereFound:                                   NoProductsWereFound
 - OnlyTheJudoPartnerCanSubmitSimpleApplications:         OnlyTheJudoPartnerCanSubmitSimpleApplications
 - UnableToParseDocument:                                 UnableToParseDocument
 - UnableToFindADefaultAccountLocation:                   UnableToFindADefaultAccountLocation
 - WebpaymentsShouldBeCreatedByPostingToUrl:              WebpaymentsShouldBeCreatedByPostingToUrl
 - InvalidMd:                                             InvalidMd
 - InvalidReceiptId:                                      InvalidReceiptId
 - ParameterError:                                        ParameterError
 - ResponseParseError:                                    ResponseParseError
 - LuhnValidationError:                                   LuhnValidationError
 - JudoIDInvalidError:                                    JudoIDInvalidError
 - SerializationError:                                    SerializationError
 - RequestError:                                          RequestError
 - TokenSecretError:                                      TokenSecretError
 - AmountMissingError:                                    AmountMissingError
 - CardAndTokenError:                                     CardAndTokenError
 - CardOrTokenMissingError:                               CardOrTokenMissingError
 - PKPaymentMissingError:                                 PKPaymentMissingError
 - JailbrokenDeviceDisallowedError:                       JailbrokenDeviceDisallowedError
 - InvalidOperationError:                                 InvalidOperationError
 - DuplicateTransactionError:                             DuplicateTransactionError
 - CurrencyNotSupportedError:                             CurrencyNotSupportedError
 - LocationServicesDisabled:                              LocationServicesDisabled
 - CardLengthMismatchError:                               CardLengthMismatchError
 - InputLengthMismatchError:                              InputLengthMismatchError
 - InvalidCardNumber:                                     InvalidCardNumber
 - InvalidEntry:                                          InvalidEntry
 - InvalidCardNetwork:                                    InvalidCardNetwork
 - InvalidPostCodeError:                                  InvalidPostCodeError
 - ThreeDSAuthRequest:                                    ThreeDSAuthRequest
 - Failed3DSError:                                        Failed3DSError
 - UnknownError:                                          UnknownError
 - UserDidCancel:                                         UserDidCancel
 */
public enum JudoErrorCode: Int {
    
    /// General_Error   
    case general_Error = 0
    /// General_Model_Error
    case general_Model_Error = 1
    /// Unauthorized
    case unauthorized = 7
    /// Payment_System_Error
    case payment_System_Error = 9
    /// Payment_Declined
    case payment_Declined = 11
    /// Payment_Failed
    case payment_Failed = 12
    /// Transaction_Not_Found
    case transaction_Not_Found = 19
    /// Validation_Passed
    case validation_Passed = 20
    /// Uncaught_Error
    case uncaught_Error = 21
    /// Server_Error
    case server_Error = 22
    /// Invalid_From_Date
    case invalid_From_Date = 23
    /// Invalid_To_Date
    case invalid_To_Date = 24
    /// CantFindWebPayment
    case cantFindWebPayment = 25
    /// General_Error_Simple_Application
    case general_Error_Simple_Application = 26
    /// InvalidApiVersion
    case invalidApiVersion = 40
    /// MissingApiVersion
    case missingApiVersion = 41
    /// PreAuthExpired
    case preAuthExpired = 42
    /// Collection_Original_Transaction_Wrong_Type
    case collection_Original_Transaction_Wrong_Type = 43
    /// Currency_Must_Equal_Original_Transaction
    case currency_Must_Equal_Original_Transaction = 44
    /// Cannot_Collect_A_Voided_Transaction
    case cannot_Collect_A_Voided_Transaction = 45
    /// Collection_Exceeds_PreAuth
    case collection_Exceeds_PreAuth = 46
    /// Refund_Original_Transaction_Wrong_Type
    case refund_Original_Transaction_Wrong_Type = 47
    /// Cannot_Refund_A_Voided_Transaction
    case cannot_Refund_A_Voided_Transaction = 48
    /// Refund_Exceeds_Original_Transaction
    case refund_Exceeds_Original_Transaction = 49
    /// Void_Original_Transaction_Wrong_Type
    case void_Original_Transaction_Wrong_Type = 50
    /// Void_Original_Transaction_Is_Already_Void
    case void_Original_Transaction_Is_Already_Void = 51
    /// Void_Original_Transaction_Has_Been_Collected
    case void_Original_Transaction_Has_Been_Collected = 52
    /// Void_Original_Transaction_Amount_Not_Equal_To_Preauth
    case void_Original_Transaction_Amount_Not_Equal_To_Preauth = 53
    /// UnableToAccept
    case unableToAccept = 54
    /// AccountLocationNotFound
    case accountLocationNotFound = 55
    /// AccessDeniedToTransaction
    case accessDeniedToTransaction = 56
    /// NoConsumerForTransaction
    case noConsumerForTransaction = 57
    /// TransactionNotEnrolledInThreeDSecure
    case transactionNotEnrolledInThreeDSecure = 58
    /// TransactionAlreadyAuthorizedByThreeDSecure
    case transactionAlreadyAuthorizedByThreeDSecure = 59
    /// ThreeDSecureNotSuccessful
    case threeDSecureNotSuccessful = 60
    /// ApUnableToDecrypt
    case apUnableToDecrypt = 61
    /// ReferencedTransactionNotFound
    case referencedTransactionNotFound = 62
    /// ReferencedTransactionNotSuccessful
    case referencedTransactionNotSuccessful = 63
    /// TestCardNotAllowed
    case testCardNotAllowed = 64
    /// Collection_Not_Valid
    case collection_Not_Valid = 65
    /// Refund_Original_Transaction_Null
    case refund_Original_Transaction_Null = 66
    /// Refund_Not_Valid
    case refund_Not_Valid = 67
    /// Void_Not_Valid
    case void_Not_Valid = 68
    /// Unknown
    case unknown = 69
    /// CardTokenInvalid
    case cardTokenInvalid = 70
    /// UnknownPaymentModel
    case unknownPaymentModel = 71
    /// UnableToRouteTransaction
    case unableToRouteTransaction = 72
    /// CardTypeNotSupported
    case cardTypeNotSupported = 73
    /// CardCv2Invalid
    case cardCv2Invalid = 74
    /// CardTokenDoesntMatchConsumer
    case cardTokenDoesntMatchConsumer = 75
    /// WebPaymentReferenceInvalid
    case webPaymentReferenceInvalid = 76
    /// WebPaymentAccountLocationNotFound
    case webPaymentAccountLocationNotFound = 77
    /// RegisterCardWithWrongTransactionType
    case registerCardWithWrongTransactionType = 78
    /// InvalidAmountToRegisterCard
    case invalidAmountToRegisterCard = 79
    /// ContentTypeNotSpecifiedOrUnsupported
    case contentTypeNotSpecifiedOrUnsupported = 80
    /// InternalErrorAuthenticating
    case internalErrorAuthenticating = 81
    /// TransactionNotFound
    case transactionNotFound = 82
    /// ResourceNotFound
    case resourceNotFound = 83
    /// LackOfPermissionsUnauthorized
    case lackOfPermissionsUnauthorized = 84
    /// ContentTypeNotSupported
    case contentTypeNotSupported = 85
    /// AuthenticationFailure
    case authenticationFailure = 403
    /// Not_Found
    case not_Found = 404
    /// MustProcessPreAuthByToken
    case mustProcessPreAuthByToken = 4002
    /// ApplicationModelIsNull
    case applicationModelIsNull = 20000
    /// ApplicationModelRequiresReference
    case applicationModelRequiresReference = 20001
    /// ApplicationHasAlreadyGoneLive
    case applicationHasAlreadyGoneLive = 20002
    /// MissingProductSelection
    case missingProductSelection = 20003
    /// AccountNotInSandbox
    case accountNotInSandbox = 20004
    /// ApplicationRecIdRequired
    case applicationRecIdRequired = 20005
    /// RequestNotProperlyFormatted
    case requestNotProperlyFormatted = 20006
    /// NoApplicationReferenceFound
    case noApplicationReferenceFound = 20007
    /// NotSupportedFileType
    case notSupportedFileType = 20008
    /// ErrorWithFileUpload
    case errorWithFileUpload = 20009
    /// EmptyApplicationReference
    case emptyApplicationReference = 20010
    /// ApplicationDoesNotExist
    case applicationDoesNotExist = 20011
    /// UnknownSortSpecified
    case unknownSortSpecified = 20013
    /// PageSizeLessThanOne
    case pageSizeLessThanOne = 20014
    /// PageSizeMoreThanFiveHundred
    case pageSizeMoreThanFiveHundred = 20015
    /// OffsetLessThanZero
    case offsetLessThanZero = 20016
    /// InvalidMerchantId
    case invalidMerchantId = 20017
    /// MerchantIdNotFound
    case merchantIdNotFound = 20018
    /// NoProductsWereFound
    case noProductsWereFound = 20019
    /// OnlyTheJudoPartnerCanSubmitSimpleApplications
    case onlyTheJudoPartnerCanSubmitSimpleApplications = 20020
    /// UnableToParseDocument
    case unableToParseDocument = 20021
    /// UnableToFindADefaultAccountLocation
    case unableToFindADefaultAccountLocation = 20022
    /// WebpaymentsShouldBeCreatedByPostingToUrl
    case webpaymentsShouldBeCreatedByPostingToUrl = 20023
    /// InvalidMd
    case invalidMd = 20025
    /// InvalidReceiptId
    case invalidReceiptId = 20026
    
    // MARK: Device Errors
    /// ParameterError
    case parameterError
    /// ResponseParseError
    case responseParseError
    /// LuhnValidationError
    case luhnValidationError
    /// JudoIDInvalidError
    case judoIDInvalidError
    /// SerializationError
    case serializationError
    /// RequestError
    case requestError
    /// TokenSecretError
    case tokenSecretError
    /// CardAndTokenError
    case cardAndTokenError
    /// AmountMissingError
    case amountMissingError
    /// CardOrTokenMissingError
    case cardOrTokenMissingError
    /// PKPaymentMissingError
    case pkPaymentMissingError
    /// JailbrokenDeviceDisallowedError
    case jailbrokenDeviceDisallowedError
    /// InvalidOperationError
    case invalidOperationError
    /// DuplicateTransactionError
    case duplicateTransactionError
    /// CurrencyNotSupportedError
    case currencyNotSupportedError
    /// LocationServicesDisabled = 91
    case locationServicesDisabled = 91
    
    // MARK: Card Errors
    /// CardLengthMismatchError
    case cardLengthMismatchError
    /// InputLengthMismatchError
    case inputLengthMismatchError
    /// InvalidCardNumber
    case invalidCardNumber
    /// InvalidEntry
    case invalidEntry
    /// InvalidCardNetwork
    case invalidCardNetwork
    /// InvalidPostCode
    case invalidPostCode
    
    // MARK: 3DS Error
    /// Not a real error but needed to identify when a 3DS routing has been requested by the judo API
    case threeDSAuthRequest
    /// Failed3DSError
    case failed3DSError
    /// UnknownError
    case unknownError
    
    // MARK: User Errors
    /// Received when user cancels the payment
    case userDidCancel = -999
    
    func messageValues() -> (String?, String?, String?)? {
        
        let UnableToProcessRequestErrorDesc = "Sorry, we're currently unable to process this request."
        let UnableToProcessRequestErrorTitle = "Unable to process"
        
        var title: String? = UnableToProcessRequestErrorTitle
        var message: String? = UnableToProcessRequestErrorDesc
        var hint: String?
        
        switch self {
            
            case .parameterError:
                hint = "A parameter entered into the dictionary (request body to Judo API) is faulty"

            case .responseParseError:
                hint = "An error with the response from the backend API"
            
            case .luhnValidationError:
                hint = "Luhn validation checks failed"
                title = "Unable to validate"
                message = "Sorry, we've been unable to validate your card. Please check your details and try again or use an alternative card."
            
            case .judoIDInvalidError:
                hint = "Luhn validation on JudoID failed"
                title = "Unable to accept"
                message = "Sorry, but we are currently unable to accept payments to this account. Please contact customer services."
   
            case .serializationError:
                hint = "The information returned by the backend API does not return proper JSON data"
            
            case .requestError:
                hint = "The request failed when trying to communicate to the API"
            
            case .tokenSecretError:
                hint = "Token and secret information is not provided"
            
            case .cardAndTokenError:
                hint = "Both a card and a token were provided in the transaction request"
            
            case .amountMissingError:
                hint = "An amount object was not provided in the transaction request"
 
            case .cardOrTokenMissingError:
                hint = "The card object and the token object were not provided in the transaction request"
    
            case .pkPaymentMissingError:
                hint = "The pkPayment object was not provided in the ApplePay transaction"

            case .jailbrokenDeviceDisallowedError:
                hint = "The device the code is currently running is jailbroken. Jailbroken devices are not allowed when instantiating a new Judo session"
 
            case .invalidOperationError:
                hint = "It is not possible to create a transaction object with anything else than Payment, PreAuth or RegisterCard"
    
            case .failed3DSError:
                hint = "After receiving the 3DS payload, when the payload has faulty data, the WebView fails to load the 3DS Page or the resolution page"
    
            case .unknownError:
                hint = "An unknown error that can occur when making API calls"

            case .userDidCancel:
                hint = "Received when user cancels the payment journey"
                title = nil
                message = nil
            
            default:
                return nil
        }
        
        return (title, message, hint)
    }
}

