//
//  SettingsSection.swift
//  makeshop
//
//  Created by Richmond Aisabor on 9/11/21.
//

import Firebase
import JGProgressHUD
import SDWebImage


protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }

}



enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Social
    case Communications
    
    var description: String {
        switch self {
        case .Social: return "Social"
        case .Communications: return "Communications"
        }
    }
    
    
}

enum SocialOptions: Int, CaseIterable, SectionType{
    case logOut
    case donate
   
    
    var containsSwitch: Bool { return false }
    
    var description: String {
        
        switch self {
        case .logOut: return "Log Out"
        case .donate: return "Donate"
        }
        
    }

        
     
}
    


enum CommunicationOptions: Int, CaseIterable, SectionType {
   
    
    case notifications
    case email
    case reportCrashes
   
    
    var containsButton: Bool { return false }

    var containsSwitch: Bool {
        switch self{
        case .notifications: return  false
        case .email: return false
        case .reportCrashes: return false
        }
    }
 
    
    var description: String {
        switch self {
        case .notifications: return "Notifications"
        case .email: return "Email"
        case .reportCrashes: return "Report Crashes"
        }

    }

}
 
 
