//
//  MainCoordinator.swift
//  ProiectCM
//
//  Created by Cosmin Cosan - tapptitude on 20.01.2024.
//

import Foundation
import Combine
import SwiftUI

class MainCoordinatorViewModel: ObservableObject {
    @UserDefault(key: "coordinatorFlowState", defaultValue: 0)
    private var coordinatorStepValue: Int
    
    var coordinatorFlowState: CoordinatorFlow = .idle {
        didSet {
            saveCurrentFlowState()
        }
    }
    
    init() {
        self.coordinatorFlowState = CoordinatorFlow(from: coordinatorStepValue)
    }
    
    enum AuthenticationFlow: Int {
        case arrivedAtRegister
        case arrivedAtLogin
    }
    
    enum CoordinatorFlow {
        case idle
        case arrivedAtAuthentication(AuthenticationFlow)
        case arrivedAtMap
        
        var step: Int {
            switch self {
            case .idle:
                return 0
            case .arrivedAtAuthentication(let authenticationFlow):
                switch authenticationFlow {
                case .arrivedAtRegister:
                    return 1
                case .arrivedAtLogin:
                    return 2
                }
            case .arrivedAtMap:
                return 3
            }
        }
        
        init(from step: Int) {
            switch step {
            case 1:
                self = .arrivedAtAuthentication(.arrivedAtRegister)
            case 2:
                self = .arrivedAtAuthentication(.arrivedAtLogin)
            case 3:
                self = .arrivedAtMap
            default:
                self = .idle
            }
        }
        
    }
    
    func saveCurrentFlowState() {
        coordinatorStepValue = coordinatorFlowState.step
    }
}
