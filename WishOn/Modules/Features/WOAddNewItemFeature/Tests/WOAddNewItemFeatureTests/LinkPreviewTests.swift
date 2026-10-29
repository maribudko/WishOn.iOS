//
//  LinkPreviewTests.swift
//  WOAddNewItemFeatureTests
//

import Foundation
import Testing
import WOResources
@testable import WOAddNewItemFeature

@Test func parserReadsOpenGraphFields() {
    let html = """
    <html><head>
    <meta property="og:title" content="Ceramic mug">
    <meta property="og:image" content="/mug.jpg">
    <meta property="product:price:amount" content="499.50">
    <meta property="product:price:currency" content="uah">
    </head></html>
    """
    let preview = OpenGraphParser.parse(html: html, pageURL: URL(string: "https://shop.example/item")!)

    #expect(preview.title == "Ceramic mug")
    #expect(preview.imageURL?.absoluteString == "https://shop.example/mug.jpg")
    #expect(preview.price == "499.50")
    #expect(preview.currency == "UAH")
}

@Test func parserLeavesMissingFieldsEmpty() {
    let html = "<html><head><title> </title></head></html>"
    let preview = OpenGraphParser.parse(html: html, pageURL: URL(string: "https://shop.example")!)

    #expect(preview.title == nil)
    #expect(preview.imageURL == nil)
    #expect(preview.price == nil)
    #expect(preview.currency == nil)
}

@Test func parserIgnoresUnknownCurrencyAndBlankPrice() {
    let html = """
    <html><head>
    <meta property="og:title" content="Lamp">
    <meta property="og:price" content="">
    <meta property="product:price:currency" content="GBP">
    </head></html>
    """
    let preview = OpenGraphParser.parse(html: html, pageURL: URL(string: "https://shop.example")!)

    #expect(preview.title == "Lamp")
    #expect(preview.price == nil)
    #expect(preview.currency == nil)
}

private struct FixedLinkPreviewLoader: LinkPreviewLoading {
    let preview: LinkPreview
    func load(from url: URL) async -> LinkPreview? { preview }
}

@Test func linkPreviewFillsEmptyFields() async {
    let loader = FixedLinkPreviewLoader(
        preview: LinkPreview(
            title: "Notebook",
            imageURL: URL(string: "https://cdn.example/notebook.jpg"),
            price: "80",
            currency: "USD"
        )
    )
    let viewModel = AddNewItemViewModel(
        stateMachine: AddNewItemStateMachine(crossIcon: .init(icon: SFSymbolsIcon(symbol: .close))),
        stateFactory: AddNewItemStateFactory(),
        linkPreviewLoader: loader
    )
    viewModel.previewDelayNanoseconds = 0

    viewModel.onUrlChanged("https://shop.example/notebook")
    for _ in 0..<20 where viewModel.viewState.name.text != "Notebook" {
        try? await Task.sleep(nanoseconds: 50_000_000)
    }

    #expect(viewModel.viewState.name.text == "Notebook")
    #expect(viewModel.viewState.price.price == "80")
    #expect(viewModel.viewState.price.currency == "USD")
    #expect(viewModel.previewImageURL?.absoluteString == "https://cdn.example/notebook.jpg")
}
