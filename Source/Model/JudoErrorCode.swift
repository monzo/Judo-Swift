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

@objc public enum JudoErrorCode: Int {
    case General_Error = 0
    case General_Model_Error = 1
    case Unauthorized = 7
    case Payment_System_Error = 9
    case Payment_Declined = 11
    case Payment_Failed = 12
    case Transaction_Not_Found = 19
    case Validation_Passed = 20
    case Uncaught_Error = 21
    case Server_Error = 22
    case Invalid_From_Date = 23
    case Invalid_To_Date = 24
    case CantFindWebPayment = 25
    case General_Error_Simple_Application = 26
    case InvalidApiVersion = 40
    case MissingApiVersion = 41
    case PreAuthExpired = 42
    case Collection_Original_Transaction_Wrong_Type = 43
    case Currency_Must_Equal_Original_Transaction = 44
    case Cannot_Collect_A_Voided_Transaction = 45
    case Collection_Exceeds_PreAuth = 46
    case Refund_Original_Transaction_Wrong_Type = 47
    case Cannot_Refund_A_Voided_Transaction = 48
    case Refund_Exceeds_Original_Transaction = 49
    case Void_Original_Transaction_Wrong_Type = 50
    case Void_Original_Transaction_Is_Already_Void = 51
    case Void_Original_Transaction_Has_Been_Collected = 52
    case Void_Original_Transaction_Amount_Not_Equal_To_Preauth = 53
    case UnableToAccept = 54
    case AccountLocationNotFound = 55
    case AccessDeniedToTransaction = 56
    case NoConsumerForTransaction = 57
    case TransactionNotEnrolledInThreeDSecure = 58
    case TransactionAlreadyAuthorizedByThreeDSecure = 59
    case ThreeDSecureNotSuccessful = 60
    case ApUnableToDecrypt = 61
    case ReferencedTransactionNotFound = 62
    case ReferencedTransactionNotSuccessful = 63
    case TestCardNotAllowed = 64
    case Collection_Not_Valid = 65
    case Refund_Original_Transaction_Null = 66
    case Refund_Not_Valid = 67
    case Void_Not_Valid = 68
    case Unknown = 69
    case CardTokenInvalid = 70
    case UnknownPaymentModel = 71
    case UnableToRouteTransaction = 72
    case CardTypeNotSupported = 73
    case CardCv2Invalid = 74
    case CardTokenDoesntMatchConsumer = 75
    case WebPaymentReferenceInvalid = 76
    case WebPaymentAccountLocationNotFound = 77
    case RegisterCardWithWrongTransactionType = 78
    case InvalidAmountToRegisterCard = 79
    case ContentTypeNotSpecifiedOrUnsupported = 80
    case InternalErrorAuthenticating = 81
    case TransactionNotFound = 82
    case ResourceNotFound = 83
    case LackOfPermissionsUnauthorized = 84
    case ContentTypeNotSupported = 85
    case AuthenticationFailure = 403
    case Not_Found = 404
    case MustProcessPreAuthByToken = 4002
    case ApplicationModelIsNull = 20000
    case ApplicationModelRequiresReference = 20001
    case ApplicationHasAlreadyGoneLive = 20002
    case MissingProductSelection = 20003
    case AccountNotInSandbox = 20004
    case ApplicationRecIdRequired = 20005
    case RequestNotProperlyFormatted = 20006
    case NoApplicationReferenceFound = 20007
    case NotSupportedFileType = 20008
    case ErrorWithFileUpload = 20009
    case EmptyApplicationReference = 20010
    case ApplicationDoesNotExist = 20011
    case UnknownSortSpecified = 20013
    case PageSizeLessThanOne = 20014
    case PageSizeMoreThanFiveHundred = 20015
    case OffsetLessThanZero = 20016
    case InvalidMerchantId = 20017
    case MerchantIdNotFound = 20018
    case NoProductsWereFound = 20019
    case OnlyTheJudoPartnerCanSubmitSimpleApplications = 20020
    case UnableToParseDocument = 20021
    case UnableToFindADefaultAccountLocation = 20022
    case WebpaymentsShouldBeCreatedByPostingToUrl = 20023
    case InvalidMd = 20025
    case InvalidReceiptId = 20026
    
    // MARK: Device Errors
    case ParameterError
    case ResponseParseError
    case LuhnValidationError
    case JudoIDInvalidError, SerializationError, RequestError, TokenSecretError, CardAndTokenError, CardOrTokenMissingError, PKPaymentMissingError, JailbrokenDeviceDisallowedError, InvalidOperationError, DuplicateTransactionError, CurrencyNotSupportedError
    case LocationServicesDisabled = 91
    
    // MARK: Card Errors
    case CardLengthMismatchError, InputLengthMismatchError, InvalidCardNumber, InvalidEntry, InvalidCardNetwork
    
    // MARK: 3DS Error
    case ThreeDSAuthRequest, Failed3DSError
    
    // MARK: User Errors
    case UserDidCancel = -999
}
