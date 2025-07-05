import Testing
@testable import WOLoginFeature

@Test func googleLoginButtonActionCallsOnLoginSuccess() {
    var didCallSuccess = false
    let stateMachine = LoginStateMachine(onLoginSuccess: {
        didCallSuccess = true
    })
    
    stateMachine.state.googleLoginButton.action()
    
    #expect(didCallSuccess == true)
}

@Test func appleLoginButtonActionDoesNothingYet() {
    let stateMachine = LoginStateMachine()
    
    // Just check it doesn’t crash (smoke test)
    stateMachine.state.appleLoginButton.action()
    
    #expect(true) // Always passes — no crash
}
