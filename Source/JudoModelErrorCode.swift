//
//  JudoModelErrorCode.swift
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
 A Mirror of the backend error set
 
 - JudoId_Not_Supplied:                               JudoId_Not_Supplied description
 - JudoId_Not_Supplied_1:                             JudoId_Not_Supplied_1 description
 - JudoId_Not_Valid:                                  JudoId_Not_Valid description
 - JudoId_Not_Valid_1:                                JudoId_Not_Valid_1 description
 - Amount_Greater_Than_0:                             Amount_Greater_Than_0 description
 - Amount_Not_Valid:                                  Amount_Not_Valid description
 - Amount_Two_Decimal_Places:                         Amount_Two_Decimal_Places description
 - Amount_Between_0_And_5000:                         Amount_Between_0_And_5000 description
 - Partner_Service_Fee_Not_Valid:                     Partner_Service_Fee_Not_Valid description
 - Partner_Service_Fee_Between_0_And_5000:            Partner_Service_Fee_Between_0_And_5000 description
 - Consumer_Reference_Not_Supplied:                   Consumer_Reference_Not_Supplied description
 - Consumer_Reference_Not_Supplied_1:                 Consumer_Reference_Not_Supplied_1 description
 - Consumer_Reference_Length:                         Consumer_Reference_Length description
 - Consumer_Reference_Length_1:                       Consumer_Reference_Length_1 description
 - Consumer_Reference_Length_2:                       Consumer_Reference_Length_2 description
 - Payment_Reference_Not_Supplied:                    Payment_Reference_Not_Supplied description
 - Payment_Reference_Not_Supplied_1:                  Payment_Reference_Not_Supplied_1 description
 - Payment_Reference_Not_Supplied_2:                  Payment_Reference_Not_Supplied_2 description
 - Payment_Reference_Not_Supplied_3:                  Payment_Reference_Not_Supplied_3 description
 - Payment_Reference_Length:                          Payment_Reference_Length description
 - Payment_Reference_Length_1:                        Payment_Reference_Length_1 description
 - Payment_Reference_Length_2:                        Payment_Reference_Length_2 description
 - Payment_Reference_Length_3:                        Payment_Reference_Length_3 description
 - Payment_Reference_Length_4:                        Payment_Reference_Length_4 description
 - Currency_Required:                                 Currency_Required description
 - Currency_Length:                                   Currency_Length description
 - Currency_Not_Supported:                            Currency_Not_Supported description
 - Device_Category_Unknown:                           Device_Category_Unknown description
 - Card_Number_Not_Supplied:                          Card_Number_Not_Supplied description
 - Test_Cards_Only_In_Sandbox:                        Test_Cards_Only_In_Sandbox description
 - Card_Number_Invalid:                               Card_Number_Invalid description
 - Three_Digit_CV2_Not_Supplied:                      Three_Digit_CV2_Not_Supplied description
 - Four_Digit_CV2_Not_Supplied:                       Four_Digit_CV2_Not_Supplied description
 - CV2_Not_Valid:                                     CV2_Not_Valid description
 - CV2_Not_Valid_1:                                   CV2_Not_Valid_1 description
 - Start_Date_Or_Issue_Number_Must_Be_Supplied:       Start_Date_Or_Issue_Number_Must_Be_Supplied description
 - Start_Date_Not_Supplied:                           Start_Date_Not_Supplied description
 - Start_Date_Wrong_Length:                           Start_Date_Wrong_Length description
 - Start_Date_Not_Valid:                              Start_Date_Not_Valid description
 - Start_Date_Not_Valid_Format:                       Start_Date_Not_Valid_Format description
 - Start_Date_Too_Far_In_Past:                        Start_Date_Too_Far_In_Past description
 - Start_Date_Month_Outside_Expected_Range:           Start_Date_Month_Outside_Expected_Range description
 - Issue_Number_Outside_Expected_Range:               Issue_Number_Outside_Expected_Range description
 - Expiry_Date_Not_Supplied:                          Expiry_Date_Not_Supplied description
 - Expiry_Date_Wrong_Length:                          Expiry_Date_Wrong_Length description
 - Expiry_Date_Not_Valid:                             Expiry_Date_Not_Valid description
 - Expiry_Date_In_Past:                               Expiry_Date_In_Past description
 - Expiry_Date_Too_Far_In_Future:                     Expiry_Date_Too_Far_In_Future description
 - Expiry_Date_Month_Outside_Expected_Range:          Expiry_Date_Month_Outside_Expected_Range description
 - Postcode_Not_Valid:                                Postcode_Not_Valid description
 - Postcode_Not_Supplied:                             Postcode_Not_Supplied description
 - Postcode_Is_Invalid:                               Postcode_Is_Invalid description
 - Card_Token_Not_Supplied:                           Card_Token_Not_Supplied description
 - Card_Token_Original_Transaction_Failed:            Card_Token_Original_Transaction_Failed description
 - ThreeDSecure_PaRes_Not_Supplied:                   ThreeDSecure_PaRes_Not_Supplied description
 - ReceiptId_Not_Supplied:                            ReceiptId_Not_Supplied description
 - ReceiptId_Is_Invalid:                              ReceiptId_Is_Invalid description
 - Transaction_Type_In_Url_Invalid:                   Transaction_Type_In_Url_Invalid description
 - Partner_Application_Reference_Not_Supplied:        Partner_Application_Reference_Not_Supplied description
 - Partner_Application_Reference_Not_Supplied_1:      Partner_Application_Reference_Not_Supplied_1 description
 - Type_Of_Company_Not_Supplied:                      Type_Of_Company_Not_Supplied description
 - Type_Of_Company_Unknown:                           Type_Of_Company_Unknown description
 - Principle_Not_Supplied:                            Principle_Not_Supplied description
 - Principle_Salutation_Unknown:                      Principle_Salutation_Unknown description
 - Principle_First_Name_Not_Supplied:                 Principle_First_Name_Not_Supplied description
 - Principle_First_Name_Length:                       Principle_First_Name_Length description
 - Principle_First_Name_Not_Supplied_1:               Principle_First_Name_Not_Supplied_1 description
 - Principle_Last_Name_Not_Supplied:                  Principle_Last_Name_Not_Supplied description
 - Principle_Last_Name_Length:                        Principle_Last_Name_Length description
 - Principle_Last_Name_Not_Supplied_1:                Principle_Last_Name_Not_Supplied_1 description
 - Principle_Email_Or_Mobile_Not_Supplied:            Principle_Email_Or_Mobile_Not_Supplied description
 - Principle_Email_Address_Not_supplied:              Principle_Email_Address_Not_supplied description
 - Principle_Email_Address_Length:                    Principle_Email_Address_Length description
 - Principle_Email_Address_Not_Valid:                 Principle_Email_Address_Not_Valid description
 - Principle_Email_Address_Domain_Not_Valid:          Principle_Email_Address_Domain_Not_Valid description
 - Principle_Mobile_Or_Email_Not_Supplied:            Principle_Mobile_Or_Email_Not_Supplied description
 - Principle_Mobile_Number_Not_Valid:                 Principle_Mobile_Number_Not_Valid description
 - Principle_Mobile_Number_Not_Valid_1:               Principle_Mobile_Number_Not_Valid_1 description
 - Principle_Mobile_Number_Length:                    Principle_Mobile_Number_Length description
 - Principle_Home_Phone_Not_Valid:                    Principle_Home_Phone_Not_Valid description
 - Principle_Date_Of_Birth_Not_Supplied:              Principle_Date_Of_Birth_Not_Supplied description
 - Principle_Date_Of_Birth_Not_Valid:                 Principle_Date_Of_Birth_Not_Valid description
 - Principle_Date_Of_Birth_Age:                       Principle_Date_Of_Birth_Age description
 - Location_Trading_Name_Not_Supplied:                Location_Trading_Name_Not_Supplied description
 - Location_Partner_Reference_Not_Supplied:           Location_Partner_Reference_Not_Supplied description
 - Location_Partner_Reference_Not_Supplied_1:         Location_Partner_Reference_Not_Supplied_1 description
 - Location_Partner_Reference_Length:                 Location_Partner_Reference_Length description
 - First_Name_Not_supplied:                           First_Name_Not_supplied description
 - First_Name_Length:                                 First_Name_Length description
 - Last_Name_Not_Supplied:                            Last_Name_Not_Supplied description
 - Last_Name_Length:                                  Last_Name_Length description
 - Email_Address_Not_Supplied:                        Email_Address_Not_Supplied description
 - Email_Address_Length:                              Email_Address_Length description
 - Email_Address_Not_Valid:                           Email_Address_Not_Valid description
 - Email_Address_Domain_Not_Valid:                    Email_Address_Domain_Not_Valid description
 - Schedule_Start_Date_Not_Supplied:                  Schedule_Start_Date_Not_Supplied description
 - Schedule_Start_Date_Format_Not_Valid:              Schedule_Start_Date_Format_Not_Valid description
 - Schedule_End_Date_Not_Supplied:                    Schedule_End_Date_Not_Supplied description
 - Schedule_End_Date_Format_Not_Valid:                Schedule_End_Date_Format_Not_Valid description
 - Schedule_End_Date_Must_Be_Greater_Than_Start_Date: Schedule_End_Date_Must_Be_Greater_Than_Start_Date description
 - Schedule_Repeat_Not_Supplied:                      Schedule_Repeat_Not_Supplied description
 - Schedule_Repeat_Must_Be_Greater_Than_1:            Schedule_Repeat_Must_Be_Greater_Than_1 description
 - Schedule_Interval_Not_Valid:                       Schedule_Interval_Not_Valid description
 - Schedule_Interval_Must_Be_Minimum_5:               Schedule_Interval_Must_Be_Minimum_5 description
 - ItemsPerPage_Not_Supplied:                         ItemsPerPage_Not_Supplied description
 - ItemsPerPage_Out_Of_Range:                         ItemsPerPage_Out_Of_Range description
 - PageNumber_Not_Supplied:                           PageNumber_Not_Supplied description
 - PageNumber_Out_Of_Range:                           PageNumber_Out_Of_Range description
 - Legal_Name_Not_Supplied:                           Legal_Name_Not_Supplied description
 - Company_Number_Not_Supplied:                       Company_Number_Not_Supplied description
 - Company_Number_Wrong_Length:                       Company_Number_Wrong_Length description
 - Current_Address_Not_Supplied:                      Current_Address_Not_Supplied description
 - Building_Number_Or_Name_Not_Supplied:              Building_Number_Or_Name_Not_Supplied description
 - Building_Number_Or_Name_Length:                    Building_Number_Or_Name_Length description
 - Address_Line1_Not_Supplied:                        Address_Line1_Not_Supplied description
 - Address_Line1_Length:                              Address_Line1_Length description
 - SortCode_Not_Supplied:                             SortCode_Not_Supplied description
 - SortCode_Not_Valid:                                SortCode_Not_Valid description
 - Account_Number_Not_Supplied:                       Account_Number_Not_Supplied description
 - Account_number_Not_Valid:                          Account_number_Not_Valid description
 - Location_Turnover_Greater_Than_0:                  Location_Turnover_Greater_Than_0 description
 - Average_Transaction_Value_Not_Supplied:            Average_Transaction_Value_Not_Supplied description
 - Average_Transaction_Value_Greater_Than_0:          Average_Transaction_Value_Greater_Than_0 description
 - Average_Transaction_Value_Greater_Than_Turnover:   Average_Transaction_Value_Greater_Than_Turnover description
 - MccCode_Not_Supplied:                              MccCode_Not_Supplied description
 - MccCode_Unknown:                                   MccCode_Unknown description
 - Generic_Is_Invalid:                                Generic_Is_Invalid description
 - Generic_Html_Invalid:                              Generic_Html_Invalid description
 */
public enum JudoModelErrorCode: Int {
    /// JudoId_Not_Supplied
    case judoId_Not_Supplied = 0
    /// JudoId_Not_Supplied_1
    case judoId_Not_Supplied_1 = 1
    /// JudoId_Not_Valid
    case judoId_Not_Valid = 2
    /// JudoId_Not_Valid_1
    case judoId_Not_Valid_1 = 3
    /// Amount_Greater_Than_0
    case amount_Greater_Than_0 = 4
    /// Amount_Not_Valid
    case amount_Not_Valid = 5
    /// Amount_Two_Decimal_Places
    case amount_Two_Decimal_Places = 6
    /// Amount_Between_0_And_5000
    case amount_Between_0_And_5000 = 7
    /// Partner_Service_Fee_Not_Valid
    case partner_Service_Fee_Not_Valid = 8
    /// Partner_Service_Fee_Between_0_And_5000
    case partner_Service_Fee_Between_0_And_5000 = 9
    /// Consumer_Reference_Not_Supplied
    case consumer_Reference_Not_Supplied = 10
    /// Consumer_Reference_Not_Supplied_1
    case consumer_Reference_Not_Supplied_1 = 11
    /// Consumer_Reference_Length
    case consumer_Reference_Length = 12
    /// Consumer_Reference_Length_1
    case consumer_Reference_Length_1 = 13
    /// Consumer_Reference_Length_2
    case consumer_Reference_Length_2 = 14
    /// Payment_Reference_Not_Supplied
    case payment_Reference_Not_Supplied = 15
    /// Payment_Reference_Not_Supplied_1
    case payment_Reference_Not_Supplied_1 = 16
    /// Payment_Reference_Not_Supplied_2
    case payment_Reference_Not_Supplied_2 = 17
    /// Payment_Reference_Not_Supplied_3
    case payment_Reference_Not_Supplied_3 = 18
    /// Payment_Reference_Length
    case payment_Reference_Length = 19
    /// Payment_Reference_Length_1
    case payment_Reference_Length_1 = 20
    /// Payment_Reference_Length_2
    case payment_Reference_Length_2 = 21
    /// Payment_Reference_Length_3
    case payment_Reference_Length_3 = 22
    /// Payment_Reference_Length_4
    case payment_Reference_Length_4 = 23
    /// Currency_Required
    case currency_Required = 24
    /// Currency_Length
    case currency_Length = 25
    /// Currency_Not_Supported
    case currency_Not_Supported = 26
    /// Device_Category_Unknown
    case device_Category_Unknown = 27
    /// Card_Number_Not_Supplied
    case card_Number_Not_Supplied = 28
    /// Test_Cards_Only_In_Sandbox
    case test_Cards_Only_In_Sandbox = 29
    /// Card_Number_Invalid
    case card_Number_Invalid = 30
    /// Three_Digit_CV2_Not_Supplied
    case three_Digit_CV2_Not_Supplied = 31
    /// Four_Digit_CV2_Not_Supplied
    case four_Digit_CV2_Not_Supplied = 32
    /// CV2_Not_Valid
    case cv2_Not_Valid = 33
    /// CV2_Not_Valid_1
    case cv2_Not_Valid_1 = 34
    /// Start_Date_Or_Issue_Number_Must_Be_Supplied
    case start_Date_Or_Issue_Number_Must_Be_Supplied = 35
    /// Start_Date_Not_Supplied
    case start_Date_Not_Supplied = 36
    /// Start_Date_Wrong_Length
    case start_Date_Wrong_Length = 37
    /// Start_Date_Not_Valid
    case start_Date_Not_Valid = 38
    /// Start_Date_Not_Valid_Format
    case start_Date_Not_Valid_Format = 39
    /// Start_Date_Too_Far_In_Past
    case start_Date_Too_Far_In_Past = 40
    /// Start_Date_Month_Outside_Expected_Range
    case start_Date_Month_Outside_Expected_Range = 41
    /// Issue_Number_Outside_Expected_Range
    case issue_Number_Outside_Expected_Range = 42
    /// Expiry_Date_Not_Supplied
    case expiry_Date_Not_Supplied = 43
    /// Expiry_Date_Wrong_Length
    case expiry_Date_Wrong_Length = 44
    /// Expiry_Date_Not_Valid
    case expiry_Date_Not_Valid = 45
    /// Expiry_Date_In_Past
    case expiry_Date_In_Past = 46
    /// Expiry_Date_Too_Far_In_Future
    case expiry_Date_Too_Far_In_Future = 47
    /// Expiry_Date_Month_Outside_Expected_Range
    case expiry_Date_Month_Outside_Expected_Range = 48
    /// Postcode_Not_Valid
    case postcode_Not_Valid = 49
    /// Postcode_Not_Supplied
    case postcode_Not_Supplied = 50
    /// Postcode_Is_Invalid
    case postcode_Is_Invalid = 51
    /// Card_Token_Not_Supplied
    case card_Token_Not_Supplied = 52
    /// Card_Token_Original_Transaction_Failed
    case card_Token_Original_Transaction_Failed = 53
    /// ThreeDSecure_PaRes_Not_Supplied
    case threeDSecure_PaRes_Not_Supplied = 54
    /// ReceiptId_Not_Supplied
    case receiptId_Not_Supplied = 55
    /// ReceiptId_Is_Invalid
    case receiptId_Is_Invalid = 56
    /// Transaction_Type_In_Url_Invalid
    case transaction_Type_In_Url_Invalid = 57
    /// Partner_Application_Reference_Not_Supplied
    case partner_Application_Reference_Not_Supplied = 58
    /// Partner_Application_Reference_Not_Supplied_1
    case partner_Application_Reference_Not_Supplied_1 = 59
    /// Type_Of_Company_Not_Supplied
    case type_Of_Company_Not_Supplied = 60
    /// Type_Of_Company_Unknown
    case type_Of_Company_Unknown = 61
    /// Principle_Not_Supplied
    case principle_Not_Supplied = 62
    /// Principle_Salutation_Unknown
    case principle_Salutation_Unknown = 63
    /// Principle_First_Name_Not_Supplied
    case principle_First_Name_Not_Supplied = 64
    /// Principle_First_Name_Length
    case principle_First_Name_Length = 65
    /// Principle_First_Name_Not_Supplied_1
    case principle_First_Name_Not_Supplied_1 = 66
    /// Principle_Last_Name_Not_Supplied
    case principle_Last_Name_Not_Supplied = 67
    /// Principle_Last_Name_Length
    case principle_Last_Name_Length = 68
    /// Principle_Last_Name_Not_Supplied_1
    case principle_Last_Name_Not_Supplied_1 = 69
    /// Principle_Email_Or_Mobile_Not_Supplied
    case principle_Email_Or_Mobile_Not_Supplied = 70
    /// Principle_Email_Address_Not_supplied
    case principle_Email_Address_Not_supplied = 71
    /// Principle_Email_Address_Length
    case principle_Email_Address_Length = 72
    /// Principle_Email_Address_Not_Valid
    case principle_Email_Address_Not_Valid = 73
    /// Principle_Email_Address_Domain_Not_Valid
    case principle_Email_Address_Domain_Not_Valid = 74
    /// Principle_Mobile_Or_Email_Not_Supplied
    case principle_Mobile_Or_Email_Not_Supplied = 75
    /// Principle_Mobile_Number_Not_Valid
    case principle_Mobile_Number_Not_Valid = 76
    /// Principle_Mobile_Number_Not_Valid_1
    case principle_Mobile_Number_Not_Valid_1 = 77
    /// Principle_Mobile_Number_Length
    case principle_Mobile_Number_Length = 78
    /// Principle_Home_Phone_Not_Valid
    case principle_Home_Phone_Not_Valid = 79
    /// Principle_Date_Of_Birth_Not_Supplied
    case principle_Date_Of_Birth_Not_Supplied = 80
    /// Principle_Date_Of_Birth_Not_Valid
    case principle_Date_Of_Birth_Not_Valid = 81
    /// Principle_Date_Of_Birth_Age
    case principle_Date_Of_Birth_Age = 82
    /// Location_Trading_Name_Not_Supplied
    case location_Trading_Name_Not_Supplied = 83
    /// Location_Partner_Reference_Not_Supplied
    case location_Partner_Reference_Not_Supplied = 84
    /// Location_Partner_Reference_Not_Supplied_1
    case location_Partner_Reference_Not_Supplied_1 = 85
    /// Location_Partner_Reference_Length
    case location_Partner_Reference_Length = 86
    /// First_Name_Not_supplied
    case first_Name_Not_supplied = 87
    /// First_Name_Length
    case first_Name_Length = 88
    /// Last_Name_Not_Supplied
    case last_Name_Not_Supplied = 89
    /// Last_Name_Length
    case last_Name_Length = 90
    /// Email_Address_Not_Supplied
    case email_Address_Not_Supplied = 91
    /// Email_Address_Length
    case email_Address_Length = 92
    /// Email_Address_Not_Valid
    case email_Address_Not_Valid = 93
    /// Email_Address_Domain_Not_Valid
    case email_Address_Domain_Not_Valid = 94
    /// Schedule_Start_Date_Not_Supplied
    case schedule_Start_Date_Not_Supplied = 95
    /// Schedule_Start_Date_Format_Not_Valid
    case schedule_Start_Date_Format_Not_Valid = 96
    /// Schedule_End_Date_Not_Supplied
    case schedule_End_Date_Not_Supplied = 97
    /// Schedule_End_Date_Format_Not_Valid
    case schedule_End_Date_Format_Not_Valid = 98
    /// Schedule_End_Date_Must_Be_Greater_Than_Start_Date
    case schedule_End_Date_Must_Be_Greater_Than_Start_Date = 99
    /// Schedule_Repeat_Not_Supplied
    case schedule_Repeat_Not_Supplied = 100
    /// Schedule_Repeat_Must_Be_Greater_Than_1
    case schedule_Repeat_Must_Be_Greater_Than_1 = 101
    /// Schedule_Interval_Not_Valid
    case schedule_Interval_Not_Valid = 102
    /// Schedule_Interval_Must_Be_Minimum_5
    case schedule_Interval_Must_Be_Minimum_5 = 103
    /// ItemsPerPage_Not_Supplied
    case itemsPerPage_Not_Supplied = 104
    /// ItemsPerPage_Out_Of_Range
    case itemsPerPage_Out_Of_Range = 105
    /// PageNumber_Not_Supplied
    case pageNumber_Not_Supplied = 106
    /// PageNumber_Out_Of_Range
    case pageNumber_Out_Of_Range = 107
    /// Legal_Name_Not_Supplied
    case legal_Name_Not_Supplied = 108
    /// Company_Number_Not_Supplied
    case company_Number_Not_Supplied = 109
    /// Company_Number_Wrong_Length
    case company_Number_Wrong_Length = 110
    /// Current_Address_Not_Supplied
    case current_Address_Not_Supplied = 111
    /// Building_Number_Or_Name_Not_Supplied
    case building_Number_Or_Name_Not_Supplied = 112
    /// Building_Number_Or_Name_Length
    case building_Number_Or_Name_Length = 113
    /// Address_Line1_Not_Supplied
    case address_Line1_Not_Supplied = 114
    /// Address_Line1_Length
    case address_Line1_Length = 115
    /// SortCode_Not_Supplied
    case sortCode_Not_Supplied = 116
    /// SortCode_Not_Valid
    case sortCode_Not_Valid = 117
    /// Account_Number_Not_Supplied
    case account_Number_Not_Supplied = 118
    /// Account_number_Not_Valid
    case account_number_Not_Valid = 119
    /// Location_Turnover_Greater_Than_0
    case location_Turnover_Greater_Than_0 = 120
    /// Average_Transaction_Value_Not_Supplied
    case average_Transaction_Value_Not_Supplied = 121
    /// Average_Transaction_Value_Greater_Than_0
    case average_Transaction_Value_Greater_Than_0 = 122
    /// Average_Transaction_Value_Greater_Than_Turnover
    case average_Transaction_Value_Greater_Than_Turnover = 123
    /// MccCode_Not_Supplied
    case mccCode_Not_Supplied = 124
    /// MccCode_Unknown
    case mccCode_Unknown = 125
    /// Generic_Is_Invalid
    case generic_Is_Invalid = 200
    /// Generic_Html_Invalid
    case generic_Html_Invalid = 210
}
