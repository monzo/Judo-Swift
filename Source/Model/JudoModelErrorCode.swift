//
//  JudoModelErrorCode.swift
//  Judo
//
//  Copyright (c) 2015 Alternative Payments Ltd
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

@objc public enum JudoModelErrorCode: Int {
    case JudoId_Not_Supplied = 0
    case JudoId_Not_Supplied_1 = 1
    case JudoId_Not_Valid = 2
    case JudoId_Not_Valid_1 = 3
    case Amount_Greater_Than_0 = 4
    case Amount_Not_Valid = 5
    case Amount_Two_Decimal_Places = 6
    case Amount_Between_0_And_5000 = 7
    case Partner_Service_Fee_Not_Valid = 8
    case Partner_Service_Fee_Between_0_And_5000 = 9
    case Consumer_Reference_Not_Supplied = 10
    case Consumer_Reference_Not_Supplied_1 = 11
    case Consumer_Reference_Length = 12
    case Consumer_Reference_Length_1 = 13
    case Consumer_Reference_Length_2 = 14
    case Payment_Reference_Not_Supplied = 15
    case Payment_Reference_Not_Supplied_1 = 16
    case Payment_Reference_Not_Supplied_2 = 17
    case Payment_Reference_Not_Supplied_3 = 18
    case Payment_Reference_Length = 19
    case Payment_Reference_Length_1 = 20
    case Payment_Reference_Length_2 = 21
    case Payment_Reference_Length_3 = 22
    case Payment_Reference_Length_4 = 23
    case Currency_Required = 24
    case Currency_Length = 25
    case Currency_Not_Supported = 26
    case Device_Category_Unknown = 27
    case Card_Number_Not_Supplied = 28
    case Test_Cards_Only_In_Sandbox = 29
    case Card_Number_Invalid = 30
    case Three_Digit_CV2_Not_Supplied = 31
    case Four_Digit_CV2_Not_Supplied = 32
    case CV2_Not_Valid = 33
    case CV2_Not_Valid_1 = 34
    case Start_Date_Or_Issue_Number_Must_Be_Supplied = 35
    case Start_Date_Not_Supplied = 36
    case Start_Date_Wrong_Length = 37
    case Start_Date_Not_Valid = 38
    case Start_Date_Not_Valid_Format = 39
    case Start_Date_Too_Far_In_Past = 40
    case Start_Date_Month_Outside_Expected_Range = 41
    case Issue_Number_Outside_Expected_Range = 42
    case Expiry_Date_Not_Supplied = 43
    case Expiry_Date_Wrong_Length = 44
    case Expiry_Date_Not_Valid = 45
    case Expiry_Date_In_Past = 46
    case Expiry_Date_Too_Far_In_Future = 47
    case Expiry_Date_Month_Outside_Expected_Range = 48
    case Postcode_Not_Valid = 49
    case Postcode_Not_Supplied = 50
    case Postcode_Is_Invalid = 51
    case Card_Token_Not_Supplied = 52
    case Card_Token_Original_Transaction_Failed = 53
    case ThreeDSecure_PaRes_Not_Supplied = 54
    case ReceiptId_Not_Supplied = 55
    case ReceiptId_Is_Invalid = 56
    case Transaction_Type_In_Url_Invalid = 57
    case Partner_Application_Reference_Not_Supplied = 58
    case Partner_Application_Reference_Not_Supplied_1 = 59
    case Type_Of_Company_Not_Supplied = 60
    case Type_Of_Company_Unknown = 61
    case Principle_Not_Supplied = 62
    case Principle_Salutation_Unknown = 63
    case Principle_First_Name_Not_Supplied = 64
    case Principle_First_Name_Length = 65
    case Principle_First_Name_Not_Supplied_1 = 66
    case Principle_Last_Name_Not_Supplied = 67
    case Principle_Last_Name_Length = 68
    case Principle_Last_Name_Not_Supplied_1 = 69
    case Principle_Email_Or_Mobile_Not_Supplied = 70
    case Principle_Email_Address_Not_supplied = 71
    case Principle_Email_Address_Length = 72
    case Principle_Email_Address_Not_Valid = 73
    case Principle_Email_Address_Domain_Not_Valid = 74
    case Principle_Mobile_Or_Email_Not_Supplied = 75
    case Principle_Mobile_Number_Not_Valid = 76
    case Principle_Mobile_Number_Not_Valid_1 = 77
    case Principle_Mobile_Number_Length = 78
    case Principle_Home_Phone_Not_Valid = 79
    case Principle_Date_Of_Birth_Not_Supplied = 80
    case Principle_Date_Of_Birth_Not_Valid = 81
    case Principle_Date_Of_Birth_Age = 82
    case Location_Trading_Name_Not_Supplied = 83
    case Location_Partner_Reference_Not_Supplied = 84
    case Location_Partner_Reference_Not_Supplied_1 = 85
    case Location_Partner_Reference_Length = 86
    case First_Name_Not_supplied = 87
    case First_Name_Length = 88
    case Last_Name_Not_Supplied = 89
    case Last_Name_Length = 90
    case Email_Address_Not_Supplied = 91
    case Email_Address_Length = 92
    case Email_Address_Not_Valid = 93
    case Email_Address_Domain_Not_Valid = 94
    case Schedule_Start_Date_Not_Supplied = 95
    case Schedule_Start_Date_Format_Not_Valid = 96
    case Schedule_End_Date_Not_Supplied = 97
    case Schedule_End_Date_Format_Not_Valid = 98
    case Schedule_End_Date_Must_Be_Greater_Than_Start_Date = 99
    case Schedule_Repeat_Not_Supplied = 100
    case Schedule_Repeat_Must_Be_Greater_Than_1 = 101
    case Schedule_Interval_Not_Valid = 102
    case Schedule_Interval_Must_Be_Minimum_5 = 103
    case ItemsPerPage_Not_Supplied = 104
    case ItemsPerPage_Out_Of_Range = 105
    case PageNumber_Not_Supplied = 106
    case PageNumber_Out_Of_Range = 107
    case Legal_Name_Not_Supplied = 108
    case Company_Number_Not_Supplied = 109
    case Company_Number_Wrong_Length = 110
    case Current_Address_Not_Supplied = 111
    case Building_Number_Or_Name_Not_Supplied = 112
    case Building_Number_Or_Name_Length = 113
    case Address_Line1_Not_Supplied = 114
    case Address_Line1_Length = 115
    case SortCode_Not_Supplied = 116
    case SortCode_Not_Valid = 117
    case Account_Number_Not_Supplied = 118
    case Account_number_Not_Valid = 119
    case Location_Turnover_Greater_Than_0 = 120
    case Average_Transaction_Value_Not_Supplied = 121
    case Average_Transaction_Value_Greater_Than_0 = 122
    case Average_Transaction_Value_Greater_Than_Turnover = 123
    case MccCode_Not_Supplied = 124
    case MccCode_Unknown = 125
    case Generic_Is_Invalid = 200
    case Generic_Html_Invalid = 210
}
