import Foundation

/// A key that defines a custom property and type made available through NetworkingValues.
public protocol NetworkingKey {
    
    /// The type of value made accessible.
    associatedtype Value
    
    /// The default value.
    static var defaultValue: Value { get }
}
