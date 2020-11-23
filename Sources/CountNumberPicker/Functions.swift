//
//  Functions.swift
//  CountNumberPicker
//
//  Created by Dmitry Anokhin on 23.11.2020.
//

public typealias Action = () -> Void
public typealias Handler<T> = (T) -> Void

func setup<Type>(_ object: Type, block: (Type) -> Void) -> Type {
    block(object)
    return object
}
