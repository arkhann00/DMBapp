//
//  RegisterEnum.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 21.09.2024.
//

import Foundation

enum RegisterViewEnum {
    
    case none
    case loading
    
    case successReg
    case nicknameIsTaken
    case databaseError
    case missingRequestField
    case emptyField
    case invalidInputFormat
    case accountAlreadyExists
    case failureReg
    
    case successAuth
    case incorrectPassword
    case accountNotVerified
    case dataNotFound
    case failureAuth
    
    case accountAlreadyVerified
    case optSendingUnavailable
    case failureSendResetPassword
    
    case successSaveTimer
    case failureSaveTimer
    
    case successEmailVerify
    case failureEmailVerify
    
    case successSendPasswordResetOtp
    case failureSendPasswordResetOtp
    
    case successPasswordReset
    case failurePasswordReset
    
    case successVerifyPasswordReset
    case failureVerifyPasswordReset
    
}
