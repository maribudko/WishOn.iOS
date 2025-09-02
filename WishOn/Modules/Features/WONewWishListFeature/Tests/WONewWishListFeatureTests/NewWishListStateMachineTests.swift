import Testing
import WODesign
import Foundation
import WOResources
@testable import WONewWishListFeature

@Test func testSettingNameAndDescription() {
    let stateMachine = makeStateMachine()
    
    stateMachine.setNameText("Birthday")
    stateMachine.setDescriptionText("Gift ideas")
    
    let state = stateMachine.state
    
    #expect(state.nameField.text == "Birthday")
    #expect(state.descriptionField.text == "Gift ideas")
}

@Test func testDatePickerVisibilityToggles() {
    let stateMachine = makeStateMachine()
    
    stateMachine.setDatePickerVisibility(true)
    #expect(stateMachine.state.datePicker.isVisible == true)
    
    stateMachine.setDatePickerVisibility(false)
    #expect(stateMachine.state.datePicker.isVisible == false)
}

@Test func testDatePickerUpdatesDate() {
    let stateMachine = makeStateMachine()
    let now = Date()
    stateMachine.onDateSelected(now)
    
    #expect(stateMachine.state.datePicker.date == now)
}

@Test func testDatePickerDismissing() {
    let stateMachine = makeStateMachine()
    stateMachine.setDatePickerVisibility(true)
    #expect(stateMachine.state.datePicker.isVisible == true)
    
    stateMachine.setDatePickerVisibility(false)
    #expect(stateMachine.state.datePicker.isVisible == false)
}

@Test func testNameTextFocusedAndValidates() {
    let stateMachine = makeStateMachine()
    
    stateMachine.setNameText("")
    stateMachine.setDidLoseFocus(.name)
    
    #expect(stateMachine.state.nameField.wasFocused == true)
    #expect(stateMachine.state.nameField.isError == true)
}

@Test func testDescriptionTextFocusedAndValidates() {
    let stateMachine = makeStateMachine()
    
    stateMachine.setDescriptionText("")
    stateMachine.setDidLoseFocus(.description)
    
    #expect(stateMachine.state.descriptionField.wasFocused == true)
    #expect(stateMachine.state.descriptionField.isError == true)
}

@Test func testErrorClearsAfterCorrectInput() {
    let stateMachine = makeStateMachine()
    
    stateMachine.setNameText("")
    stateMachine.setDidLoseFocus(.name)
    
    stateMachine.setDescriptionText("")
    stateMachine.setDidLoseFocus(.description)
    
    #expect(stateMachine.state.nameField.wasFocused == true)
    #expect(stateMachine.state.nameField.isError == true)
    #expect(stateMachine.state.descriptionField.wasFocused == true)
    #expect(stateMachine.state.descriptionField.isError == true)
    
    stateMachine.setNameText("Valid Name")
    stateMachine.setDescriptionText("Description")
    #expect(stateMachine.state.nameField.isError == false)
    #expect(stateMachine.state.descriptionField.isError == false)
}

@Test func testDatePickerDismiss() {
    let stateMachine = makeStateMachine()
    stateMachine.setDatePickerVisibility(true)
    #expect(stateMachine.state.datePicker.isVisible == true)
    
    stateMachine.onDismiss()
    #expect(stateMachine.state.datePicker.isVisible == false)
}

@Test func textIconsSetUpCorrectly() {
    let back = IconState(icon: SFSymbolsIcon(symbol: .back))
    let down = IconState(icon: SFSymbolsIcon(symbol: .down))
    let arrowDown = IconState(icon: SFSymbolsIcon(symbol: .arrowDown))
    let plusCircle = IconState(icon: SFSymbolsIcon(symbol: .plusCircle))
    
    let stateMachine = NewWishListStateMachine(
        backIcon: back,
        dropDownIcon: down,
        saveIcon: arrowDown,
        plusIcon: plusCircle
    )
    
    #expect(stateMachine.state.backButtonIcon.icon.name == back.icon.name)
    #expect(stateMachine.state.dropDownIcon.icon.name == down.icon.name)
    #expect(stateMachine.state.saveIcon.icon.name == arrowDown.icon.name)
    #expect(stateMachine.state.plusIcon.icon.name == plusCircle.icon.name)
}

private func makeStateMachine() -> NewWishListStateMachine {
    return .init(
        backIcon: .init(icon: SFSymbolsIcon(symbol: .back)),
        dropDownIcon: .init(icon: SFSymbolsIcon(symbol: .down)),
        saveIcon: .init(icon: SFSymbolsIcon(symbol: .arrowDown)),
        plusIcon: .init(icon: SFSymbolsIcon(symbol: .plusCircle)))
}
