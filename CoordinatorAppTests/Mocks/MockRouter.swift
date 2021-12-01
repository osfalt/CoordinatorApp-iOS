//
//  MockRouter.swift
//  CoordinatorAppTests
//
//  Created by Dre on 01/12/2021.
//

import Combine
import CoordinatorApp
import Foundation

class MockRouter: Routable {

    private(set) var dismissed = false
    private(set) var child: Routable?

    func route(to child: Routable) {
        self.child = child
    }

    func dismiss() {
        dismissed = true
    }

}

class MockNavigationRouter: MockRouter, NavigationRoutable {

    var top: Routable? {
        children.last
    }

    private(set) var children: [Routable] = []

    var didPopPublisher: AnyPublisher<(popped: Routable, shown: Routable), Never> {
        subject.eraseToAnyPublisher()
    }
    private let subject = PassthroughSubject<(popped: Routable, shown: Routable), Never>()

    func push(_ child: Routable) {
        children.append(child)
    }

    func pop() {
        guard let popped = children.popLast(),
              let last = children.last
        else { return }
        subject.send((popped: popped, shown: last))
    }

    func popToRoot() {
        guard let popped = children.last else { return }
        children.removeLast(children.count - 1)

        guard let last = children.last else { return }
        subject.send((popped: popped, shown: last))
    }

}
