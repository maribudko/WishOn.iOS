//
//  LinkPreview.swift
//  WOAddNewItemFeature
//

import Foundation
import SwiftSoup

struct LinkPreview: Equatable {
    var title: String?
    var imageURL: URL?
    var price: String?
    var currency: String?
}

protocol LinkPreviewLoading {
    func load(from url: URL) async -> LinkPreview?
}

struct URLSessionLinkPreviewLoader: LinkPreviewLoading {
    func load(from url: URL) async -> LinkPreview? {
        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        request.setValue(
            "Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1",
            forHTTPHeaderField: "User-Agent"
        )
        guard
            let (data, response) = try? await URLSession.shared.data(for: request),
            let http = response as? HTTPURLResponse,
            (200...299).contains(http.statusCode),
            let html = String(data: data, encoding: .utf8) ?? String(data: data, encoding: .isoLatin1)
        else {
            return nil
        }
        return OpenGraphParser.parse(html: html, pageURL: url)
    }
}

enum OpenGraphParser {
    static func parse(html: String, pageURL: URL) -> LinkPreview {
        guard let document = try? SwiftSoup.parse(html) else {
            return LinkPreview()
        }

        let title = firstMeta(
            in: document,
            keys: ["og:title", "twitter:title"]
        ) ?? nonEmpty(try? document.title())

        let imageRaw = firstMeta(
            in: document,
            keys: ["og:image", "og:image:secure_url", "twitter:image"]
        )
        let priceRaw = firstMeta(
            in: document,
            keys: ["product:price:amount", "og:price:amount", "og:price"]
        )
        let currencyRaw = firstMeta(
            in: document,
            keys: ["product:price:currency", "og:price:currency"]
        )

        return LinkPreview(
            title: title,
            imageURL: imageRaw.flatMap { resolvedURL($0, relativeTo: pageURL) },
            price: priceRaw.flatMap(normalizedPrice),
            currency: currencyRaw.flatMap(normalizedCurrency)
        )
    }

    private static func firstMeta(in document: Document, keys: [String]) -> String? {
        for key in keys {
            for attribute in ["property", "name", "itemprop"] {
                guard
                    let element = try? document.select("meta[\(attribute)=\(key)]").first(),
                    let value = nonEmpty(try? element.attr("content"))
                else {
                    continue
                }
                return value
            }
        }
        return nil
    }

    private static func nonEmpty(_ value: String?) -> String? {
        let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let trimmed, !trimmed.isEmpty else { return nil }
        return trimmed
    }

    private static func resolvedURL(_ raw: String, relativeTo pageURL: URL) -> URL? {
        if let absolute = URL(string: raw), absolute.scheme == "http" || absolute.scheme == "https" {
            return absolute
        }
        return URL(string: raw, relativeTo: pageURL)?.absoluteURL
    }

    private static func normalizedPrice(_ raw: String) -> String? {
        let compact = raw
            .replacingOccurrences(of: "\u{00a0}", with: "")
            .replacingOccurrences(of: " ", with: "")
        guard let range = compact.range(of: #"[0-9]+(?:[.,][0-9]+)?"#, options: .regularExpression) else {
            return nil
        }
        let number = compact[range].replacingOccurrences(of: ",", with: ".")
        guard let value = Double(number), value > 0 else { return nil }
        return number
    }

    private static func normalizedCurrency(_ raw: String) -> String? {
        let token = raw.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        switch token {
        case "UAH", "₴", "ГРН":
            return "UAH"
        case "USD", "$":
            return "USD"
        case "EUR", "€":
            return "EUR"
        default:
            return nil
        }
    }
}
