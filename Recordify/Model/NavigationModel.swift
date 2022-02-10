//
//  NavigationModel.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 3.02.22.
//

import Foundation
import SwiftUI

public enum RoutingType {
    case forward
    case backward
}


public enum RoutingAction {
    case back
    case home
}

public enum RoutingTransition {
    case single(AnyTransition)
    case double(AnyTransition, AnyTransition)
    case none
    case `default`
    
    public static var transitions: (backward: AnyTransition, forward: AnyTransition) {
        (
            AnyTransition.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)),
            AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
        )
    }
}


struct WrapperRoutingView: Equatable, Identifiable {
    public let id: String
    public let view: AnyView
    init(_ id: String, _ view: AnyView){
        self.id = id
        self.view = view
    }
    public static func == (lhs: WrapperRoutingView, rhs: WrapperRoutingView) -> Bool {
        lhs.id == rhs.id
    }
}

struct RoutingStack {
    
    private var storage: [WrapperRoutingView] = []
    
    internal mutating func append(_ view: WrapperRoutingView){
        storage.append(view)
    }

    internal mutating func removeAll() {
        storage.removeAll()
    }

    public mutating func removeLast() {
        if storage.count > 0 { storage.removeLast() }
    }

    internal var last: WrapperRoutingView? { storage.last }

    public func checkTag(tag: String) -> Bool {
        getIndex(tag) == nil ? false : true
    }

    public mutating func move(tag: String, force: Bool = false) {
        let index = getIndex(tag)
        
        if index == nil && checkTag(tag: tag) || force {
            storage.append(storage.remove(at: index!))
        } else {
            removeLast()
        }
    }

    private func getIndex(_ tag: String) -> Int? {
        let cell = self.storage.firstIndex(where: { $0.id == tag })
        return cell
    }
}

protocol MainRouter {}

public final class RoutingController: ObservableObject{
    
    public init(_ easing: Animation){
        self.easing = easing
        self.stack = RoutingStack()
        self.routingType = .forward
    }
  
    private var stack: RoutingStack {
        didSet {
            withAnimation(self.easing) {
                self.current = self.stack.last
            }
        }
    }

    private let easing: Animation

    private(set) var routingType: RoutingType
        
    @Published internal var current: WrapperRoutingView?

    public func home(routingType: RoutingType = .backward){
        self.routingType = routingType
        self.stack.removeAll()
    }

    public func back(routingType: RoutingType = .backward){
        self.routingType = routingType
        self.stack.removeLast()
    }

    public func goTo<Element: View>(
        element: Element,
        tag: String = UUID().uuidString,
        routingType: RoutingType = .forward)
    {
        self.routingType = routingType
        if element is MainRouter { self.home() }
        stack.append(WrapperRoutingView(tag, AnyView(element)))
    }

    public func goTo(toTag tag: String, routingType: RoutingType = .backward, force: Bool = false) {
        self.stack.move(tag: tag, force: force)
    }
}


struct RouterView<Main>: View where Main: View {
    
    @StateObject var controller: RoutingController

    private let transitionsCell: (backward: AnyTransition, forward: AnyTransition)

    private let main: Main

    private var transitions: AnyTransition {
        controller.routingType == .forward ? transitionsCell.forward : transitionsCell.backward
    }
    
    public init(
        duration: Double,
        transition: RoutingTransition = .default,
        @ViewBuilder main: () -> Main)
    {
        self.init(
            easing: Animation.easeOut(duration: duration),
            transition: transition,
            main: main
        )
    }

    public init(
        easing: Animation = Animation.easeOut(duration: 0.4),
        transition: RoutingTransition = .default,
        @ViewBuilder main: () -> Main)
    {
        self.main = main()
        self._controller = StateObject(wrappedValue: RoutingController(easing))
        
        switch transition {
        case .single(let ani):
            self.transitionsCell = (ani, ani)
        case .double(let first, let second):
            self.transitionsCell = (first, second)
        case .none:
            self.transitionsCell = (.identity, .identity)
        default:
            self.transitionsCell = RoutingTransition.transitions
        }
    }
    
    var body: some View {
        ZStack{
            if (controller.current == nil){
                main
                    .transition(transitions)
                    .environmentObject(controller)
            } else {
                controller.current!.view
                    .transition(transitions)
                    .environmentObject(controller)
            }
        }
    }
}

//struct RouteLinkView<Destination, Label>: View where Destination: View, Label: View {
//    private let label: Label
//    private let destination: Destination?
//    private let tag: String?
//    private let force: Bool
//    private let action: RoutingAction?
//
//    var body: some View {
//        Button(action: { go() }) { label }
//    }
//
//    init
//    (
//        destination: Destination,
//        tag: String = UUID().uuidString,
//        @ViewBuilder label: () -> Label
//    )
//    {
//        self.destination = destination
//        self.label = label()
//        self.tag = tag
//        self.force = false
//        self.action = nil
//    }
//
//    private func go() {
//        if action == nil {
//            toTransition()
//        } else {
//            toAction()
//        }
//    }
//
//    private func toTransition(){
//        if destination != nil {
//            controller.goTo(element: destination!, tag: self.tag!)
//        } else {
//            controller.goTo(toTag: self.tag!, force: force)
//        }
//    }
//
//    private func toAction(){
//        switch self.action! {
//        case .back:
//            controller.back()
//        case .home:
//            controller.home()
//        }
//    }
//
//}
//
//
//extension RouteLinkView where Destination == Never {
//    init
//    (
//        toTag: String = UUID().uuidString,
//        force: Bool = false,
//        @ViewBuilder label: () -> Label
//    )
//    {
//        self.destination = nil
//        self.label = label()
//        self.tag = toTag
//        self.force = force
//        self.action = nil
//    }
//
//    init
//    (
//        action: RoutingAction = .back,
//        @ViewBuilder label: () -> Label
//    )
//    {
//        self.destination = nil
//        self.label = label()
//        self.tag = nil
//        self.force = false
//        self.action = action
//    }
//}
