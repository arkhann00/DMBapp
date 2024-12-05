//
//  MessageEnum.swift
//  DMBapp
//
//  Created by Khachatryan Arsen on 13.11.2024.
//

import Foundation

enum MessageViewState {
    
    case none
    case loading
    
    case successFetchFirstPartOfMessages
    case failureFetchFirstPartOfMessages
    
    case successFetchMorePartOfMessages
    case failureFetchMorePartOfMessages
    
    case successFetchChats
    case failureFetchChats
    
    case successSentMessage
    case failureSentMessage
    
}
