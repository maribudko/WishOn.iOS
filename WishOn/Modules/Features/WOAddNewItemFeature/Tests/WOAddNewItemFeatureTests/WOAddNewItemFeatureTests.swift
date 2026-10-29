import Testing
import WOResources
@testable import WOAddNewItemFeature

@Test func buttonInitialyDisabled() {
    let stateMachine = makeStateMachine()
    #expect(stateMachine.state.addButton.isEnabled == false)
}

@Test func buttonDisablesWhenFieldInvalidates() {
    let stateMachine = makeStateMachine()
    stateMachine.setNameText("Some Name")
    stateMachine.setUrlText("https://google.com")
    stateMachine.setPriceText("120.0")
    
    #expect(stateMachine.state.addButton.isEnabled == true)
    
    stateMachine.setUrlText("")
    #expect(stateMachine.state.addButton.isEnabled == true)
}

@Test func buttonEnabledWithoutLink() {
    let stateMachine = makeStateMachine()
    stateMachine.setNameText("Notebook")
    stateMachine.setPriceText("40")
    #expect(stateMachine.state.addButton.isEnabled == true)
}

@Test func buttonEnabledWhenValidFields() {
    let stateMachine = makeStateMachine()
    stateMachine.setNameText("New Item")
    stateMachine.setUrlText("https://google.com")
    stateMachine.setPriceText("20.0")
    #expect(stateMachine.state.addButton.isEnabled == true)
}

@Test func alertShownWhenInvalid() async throws{
    let stateMachine = makeStateMachine()
    
    var shownMessage: String?
    stateMachine.didRequestShowAlert = { message in
        shownMessage = message
    }
    
    stateMachine.didTapAddButton()
    #expect(shownMessage == L10n.fillAllFields)
}

@Test func currencyChanges() {
    let stateMachine = makeStateMachine()
    
    stateMachine.setCurrencyText(L10n.eur)
    #expect(stateMachine.state.priceField.currency == L10n.eur)
}

@Test func fieldLosesFocus() {
    let stateMachine = makeStateMachine()
    
    stateMachine.setDidLoseFocus(.name)
    stateMachine.setDidLoseFocus(.url)
    stateMachine.setDidLoseFocus(.price)
    
    #expect(stateMachine.state.nameField.wasFocused == true, "Name field should be focused")
    #expect(stateMachine.state.urlField.wasFocused == true, "URL field should be focused")
    #expect(stateMachine.state.priceField.wasFocused == true, "Price field should be focused")
}

@Test func priceInputCallbacks() {
    var priceChangedCalled = false
    var currencyChangedCalled = false
    
    let priceField = AddNewItemStateMachine.PriceInputState(
        onPriceChanged: { _ in priceChangedCalled = true },
        onCurrencyChanged: { _ in currencyChangedCalled = true }
    )
    
    priceField.onPriceChanged("200")
    priceField.onCurrencyChanged("EUR")
    
    #expect(priceChangedCalled == true)
    #expect(currencyChangedCalled == true)
}

@Test func invalidUrlDisablesButton() {
    let stateMachine = makeStateMachine()
    
    stateMachine.setNameText("Test name")
    stateMachine.setUrlText("https://google.com")
    stateMachine.setPriceText("100")
    
    #expect(stateMachine.state.addButton.isEnabled == true)
    
    stateMachine.state.urlField.wasFocused = true
    stateMachine.setUrlText("google_com")
    
    #expect(stateMachine.state.addButton.isEnabled == false)
}

@Test func invalidNameDisablesButton() {
    let stateMachine = makeStateMachine()
    
    stateMachine.setNameText("Test name")
    stateMachine.setUrlText("https://google.com")
    stateMachine.setPriceText("100")
    
    #expect(stateMachine.state.addButton.isEnabled == true)
    
    stateMachine.state.nameField.wasFocused = true
    stateMachine.setNameText("T")
    
    #expect(stateMachine.state.addButton.isEnabled == false)
}

@Test func invalidPriceDisablesButton() {
    let stateMachine = makeStateMachine()
    
    stateMachine.setNameText("Test name")
    stateMachine.setUrlText("https://google.com")
    stateMachine.setPriceText("100")
    
    #expect(stateMachine.state.addButton.isEnabled == true)
    
    stateMachine.state.priceField.wasFocused = true
    stateMachine.setPriceText("0.0")
    
    #expect(stateMachine.state.addButton.isEnabled == false)
}

private func makeStateMachine() -> AddNewItemStateMachine {
    return .init(crossIcon: .init(icon: SFSymbolsIcon(symbol: .close)))
}
