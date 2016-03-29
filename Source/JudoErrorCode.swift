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
    case General_Error = 0
    /// General_Model_Error
    case General_Model_Error = 1
    /// Unauthorized
    case Unauthorized = 7
    /// Payment_System_Error
    case Payment_System_Error = 9
    /// Payment_Declined
    case Payment_Declined = 11
    /// Payment_Failed
    case Payment_Failed = 12
    /// Transaction_Not_Found
    case Transaction_Not_Found = 19
    /// Validation_Passed
    case Validation_Passed = 20
    /// Uncaught_Error
    case Uncaught_Error = 21
    /// Server_Error
    case Server_Error = 22
    /// Invalid_From_Date
    case Invalid_From_Date = 23
    /// Invalid_To_Date
    case Invalid_To_Date = 24
    /// CantFindWebPayment
    case CantFindWebPayment = 25
    /// General_Error_Simple_Application
    case General_Error_Simple_Application = 26
    /// InvalidApiVersion
    case InvalidApiVersion = 40
    /// MissingApiVersion
    case MissingApiVersion = 41
    /// PreAuthExpired
    case PreAuthExpired = 42
    /// Collection_Original_Transaction_Wrong_Type
    case Collection_Original_Transaction_Wrong_Type = 43
    /// Currency_Must_Equal_Original_Transaction
    case Currency_Must_Equal_Original_Transaction = 44
    /// Cannot_Collect_A_Voided_Transaction
    case Cannot_Collect_A_Voided_Transaction = 45
    /// Collection_Exceeds_PreAuth
    case Collection_Exceeds_PreAuth = 46
    /// Refund_Original_Transaction_Wrong_Type
    case Refund_Original_Transaction_Wrong_Type = 47
    /// Cannot_Refund_A_Voided_Transaction
    case Cannot_Refund_A_Voided_Transaction = 48
    /// Refund_Exceeds_Original_Transaction
    case Refund_Exceeds_Original_Transaction = 49
    /// Void_Original_Transaction_Wrong_Type
    case Void_Original_Transaction_Wrong_Type = 50
    /// Void_Original_Transaction_Is_Already_Void
    case Void_Original_Transaction_Is_Already_Void = 51
    /// Void_Original_Transaction_Has_Been_Collected
    case Void_Original_Transaction_Has_Been_Collected = 52
    /// Void_Original_Transaction_Amount_Not_Equal_To_Preauth
    case Void_Original_Transaction_Amount_Not_Equal_To_Preauth = 53
    /// UnableToAccept
    case UnableToAccept = 54
    /// AccountLocationNotFound
    case AccountLocationNotFound = 55
    /// AccessDeniedToTransaction
    case AccessDeniedToTransaction = 56
    /// NoConsumerForTransaction
    case NoConsumerForTransaction = 57
    /// TransactionNotEnrolledInThreeDSecure
    case TransactionNotEnrolledInThreeDSecure = 58
    /// TransactionAlreadyAuthorizedByThreeDSecure
    case TransactionAlreadyAuthorizedByThreeDSecure = 59
    /// ThreeDSecureNotSuccessful
    case ThreeDSecureNotSuccessful = 60
    /// ApUnableToDecrypt
    case ApUnableToDecrypt = 61
    /// ReferencedTransactionNotFound
    case ReferencedTransactionNotFound = 62
    /// ReferencedTransactionNotSuccessful
    case ReferencedTransactionNotSuccessful = 63
    /// TestCardNotAllowed
    case TestCardNotAllowed = 64
    /// Collection_Not_Valid
    case Collection_Not_Valid = 65
    /// Refund_Original_Transaction_Null
    case Refund_Original_Transaction_Null = 66
    /// Refund_Not_Valid
    case Refund_Not_Valid = 67
    /// Void_Not_Valid
    case Void_Not_Valid = 68
    /// Unknown
    case Unknown = 69
    /// CardTokenInvalid
    case CardTokenInvalid = 70
    /// UnknownPaymentModel
    case UnknownPaymentModel = 71
    /// UnableToRouteTransaction
    case UnableToRouteTransaction = 72
    /// CardTypeNotSupported
    case CardTypeNotSupported = 73
    /// CardCv2Invalid
    case CardCv2Invalid = 74
    /// CardTokenDoesntMatchConsumer
    case CardTokenDoesntMatchConsumer = 75
    /// WebPaymentReferenceInvalid
    case WebPaymentReferenceInvalid = 76
    /// WebPaymentAccountLocationNotFound
    case WebPaymentAccountLocationNotFound = 77
    /// RegisterCardWithWrongTransactionType
    case RegisterCardWithWrongTransactionType = 78
    /// InvalidAmountToRegisterCard
    case InvalidAmountToRegisterCard = 79
    /// ContentTypeNotSpecifiedOrUnsupported
    case ContentTypeNotSpecifiedOrUnsupported = 80
    /// InternalErrorAuthenticating
    case InternalErrorAuthenticating = 81
    /// TransactionNotFound
    case TransactionNotFound = 82
    /// ResourceNotFound
    case ResourceNotFound = 83
    /// LackOfPermissionsUnauthorized
    case LackOfPermissionsUnauthorized = 84
    /// ContentTypeNotSupported
    case ContentTypeNotSupported = 85
    /// AuthenticationFailure
    case AuthenticationFailure = 403
    /// Not_Found
    case Not_Found = 404
    /// MustProcessPreAuthByToken
    case MustProcessPreAuthByToken = 4002
    /// ApplicationModelIsNull
    case ApplicationModelIsNull = 20000
    /// ApplicationModelRequiresReference
    case ApplicationModelRequiresReference = 20001
    /// ApplicationHasAlreadyGoneLive
    case ApplicationHasAlreadyGoneLive = 20002
    /// MissingProductSelection
    case MissingProductSelection = 20003
    /// AccountNotInSandbox
    case AccountNotInSandbox = 20004
    /// ApplicationRecIdRequired
    case ApplicationRecIdRequired = 20005
    /// RequestNotProperlyFormatted
    case RequestNotProperlyFormatted = 20006
    /// NoApplicationReferenceFound
    case NoApplicationReferenceFound = 20007
    /// NotSupportedFileType
    case NotSupportedFileType = 20008
    /// ErrorWithFileUpload
    case ErrorWithFileUpload = 20009
    /// EmptyApplicationReference
    case EmptyApplicationReference = 20010
    /// ApplicationDoesNotExist
    case ApplicationDoesNotExist = 20011
    /// UnknownSortSpecified
    case UnknownSortSpecified = 20013
    /// PageSizeLessThanOne
    case PageSizeLessThanOne = 20014
    /// PageSizeMoreThanFiveHundred
    case PageSizeMoreThanFiveHundred = 20015
    /// OffsetLessThanZero
    case OffsetLessThanZero = 20016
    /// InvalidMerchantId
    case InvalidMerchantId = 20017
    /// MerchantIdNotFound
    case MerchantIdNotFound = 20018
    /// NoProductsWereFound
    case NoProductsWereFound = 20019
    /// OnlyTheJudoPartnerCanSubmitSimpleApplications
    case OnlyTheJudoPartnerCanSubmitSimpleApplications = 20020
    /// UnableToParseDocument
    case UnableToParseDocument = 20021
    /// UnableToFindADefaultAccountLocation
    case UnableToFindADefaultAccountLocation = 20022
    /// WebpaymentsShouldBeCreatedByPostingToUrl
    case WebpaymentsShouldBeCreatedByPostingToUrl = 20023
    /// InvalidMd
    case InvalidMd = 20025
    /// InvalidReceiptId
    case InvalidReceiptId = 20026
    
    // MARK: Device Errors
    /// ParameterError
    case ParameterError
    /// ResponseParseError
    case ResponseParseError
    /// LuhnValidationError
    case LuhnValidationError
    /// JudoIDInvalidError
    case JudoIDInvalidError
    /// SerializationError
    case SerializationError
    /// RequestError
    case RequestError
    /// TokenSecretError
    case TokenSecretError
    /// CardAndTokenError
    case CardAndTokenError
    /// AmountMissingError
    case AmountMissingError
    /// CardOrTokenMissingError
    case CardOrTokenMissingError
    /// PKPaymentMissingError
    case PKPaymentMissingError
    /// JailbrokenDeviceDisallowedError
    case JailbrokenDeviceDisallowedError
    /// InvalidOperationError
    case InvalidOperationError
    /// DuplicateTransactionError
    case DuplicateTransactionError
    /// CurrencyNotSupportedError
    case CurrencyNotSupportedError
    /// LocationServicesDisabled = 91
    case LocationServicesDisabled = 91
    
    // MARK: Card Errors
    /// CardLengthMismatchError
    case CardLengthMismatchError
    /// InputLengthMismatchError
    case InputLengthMismatchError
    /// InvalidCardNumber
    case InvalidCardNumber
    /// InvalidEntry
    case InvalidEntry
    /// InvalidCardNetwork
    case InvalidCardNetwork
    /// InvalidPostCode
    case InvalidPostCode
    
    // MARK: 3DS Error
    /// Not a real error but needed to identify when a 3DS routing has been requested by the judo API
    case ThreeDSAuthRequest
    /// Failed3DSError
    case Failed3DSError
    /// UnknownError
    case UnknownError
    
    // MARK: User Errors
    /// Received when user cancels the payment
    case UserDidCancel = -999
}
