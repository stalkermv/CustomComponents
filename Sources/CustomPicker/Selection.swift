//
//  Selection.swift
//  CustomComponents
//
//  Created by Valeriy Malishevskyi on 13.05.2025.
//

import SwiftUI

enum Selection<T: Hashable> : DynamicProperty {
    case single(Binding<T>)
    case optional(Binding<T?>)
    case multiple(Binding<Set<T>>)
    
    @_disfavoredOverload
    init(_ binding: Binding<T>) {
        self = .single(binding)
    }
    
    init(_ binding: Binding<T?>) {
        self = .optional(binding)
    }
    
    init(_ binding: Binding<Set<T>>) {
        self = .multiple(binding)
    }
    
    func contains(_ value: T) -> Bool {
        switch self {
        case .single(let binding):
            return value == binding.wrappedValue
        case .optional(let binding):
            return value == binding.wrappedValue
        case .multiple(let binding):
            return binding.wrappedValue.contains(value)
        }
    }
    
    func select(_ value: T) {
        switch self {
        case .single(let binding):
            binding.wrappedValue = value
        case .optional(let binding):
            binding.wrappedValue = value
        case .multiple(let binding):
            binding.wrappedValue.insert(value)
        }
    }
    
    func deselect(_ value: T) {
        switch self {
        case .single:
            // We can't deselect a single selection
            break
        case .optional(let binding):
            if binding.wrappedValue == value {
                binding.wrappedValue = nil
            }
        case .multiple(let binding):
            binding.wrappedValue.remove(value)
        }
    }
    
    func toggle(_ value: T) {
        if contains(value) {
            deselect(value)
        } else {
            select(value)
        }
    }
    
    @MainActor var binding: Binding<AnyHashable> {
        switch self {
        case .single(let binding):
            return .init(
                get: { AnyHashable(binding.wrappedValue) },
                set: { binding.wrappedValue = $0.base as! T }
            )
        case .optional(let binding):
            return .init(
                get: { AnyHashable(binding.wrappedValue) },
                set: { binding.wrappedValue = $0 as? T }
            )
        case .multiple(let binding):
            return .init(
                get: { AnyHashable(binding.wrappedValue) },
                set: { binding.wrappedValue = $0.base as! Set<T> }
            )
        }
    }
}
