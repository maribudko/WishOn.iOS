import Testing
import WOResources
@testable import WOLoginFeature

@Test func testGoogleLoginButtonLabelAndKind() {
    let googleButton = LoginStateMachine().state.googleLoginButton
    #expect(googleButton.label == L10n.googleLoginLabel)
    #expect(googleButton.kind == .googleLogin)
}

@Test func testAppleLoginButtonLabelAndKind() {
    let appleButton = LoginStateMachine().state.appleLoginButton
    #expect(appleButton.label == L10n.appleLoginLabel)
    #expect(appleButton.kind == .appleLogin)
}

