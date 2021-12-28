# NetworkingValues

A simple value type that can be extended and used to make HTTP requests.

## Defining Keys

`NetworkingValues` contains everything needed to create HTTP requests. To add custom properties use `NetworkingKey` to define a key that defines a type and default value of that type.

    enum URLSessionKey: NetworkingKey {
        typealias Value = URLSession
        static var defaultValue: Value { .shared }
    }

Then create a computed property. This is very similar to defining a custom environment property using SwiftUI's `EnvironmentKey`.

    extension NetworkingValues {
        
        var session: URLSession {
            get { self[URLSessionKey.self }
            set { self[URLSessionKey.self = newValue } 
        }
    }
    
