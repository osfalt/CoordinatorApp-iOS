//
//  DeepLinkParser.swift
//  CoordinatorApp
//
//  Created by Dre on 08/08/2021.
//

import Foundation

public enum DeepLink {
    /// coordinatorapp://greenthirdscreen?dynamictext=<String>
    case greenThirdScreen(DeepLinkPayload)
}

protocol DeepLinkParsing {
    func parseURL(url: URL) -> DeepLink?
}

struct GreenFlowDeepLinkPayload: DeepLinkPayload {
    let dynamicText: String
}

final class DeepLinkParser: DeepLinkParsing {

    func parseURL(url: URL) -> DeepLink? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }

        guard urlComponents.scheme?.lowercased() == "coordinatorapp" else {
            return nil
        }

        switch urlComponents.host?.lowercased() {
        case "greenthirdscreen":
            guard let dynamicText = urlComponents.queryItems?
                    .first(where: { $0.name.lowercased() == "dynamictext" })?
                    .value
            else {
                return nil
            }
            return .greenThirdScreen(GreenFlowDeepLinkPayload(dynamicText: dynamicText))

        default:
            return nil
        }
    }

}
