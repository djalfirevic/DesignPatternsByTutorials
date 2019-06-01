/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

public class Observable<Type> {
  
  // MARK: - Callback
  fileprivate class Callback {
    fileprivate weak var observer: AnyObject?
    fileprivate let options: [ObservableOptions]
    fileprivate let closure: (Type, ObservableOptions) -> Void
    
    fileprivate init(
      observer: AnyObject,
      options: [ObservableOptions],
      closure: @escaping (Type, ObservableOptions) -> Void) {
      self.observer = observer
      self.options = options
      self.closure = closure
    }
  }
  
  // MARK: - Properties
  public var value: Type {
    didSet {
      removeNilObserverCallbacks()
      notifyCallbacks(value: oldValue, option: .old)
      notifyCallbacks(value: value, option: .new)
    }
  }
  
  private func removeNilObserverCallbacks() {
    callbacks = callbacks.filter { $0.observer != nil }
  }
  
  private func notifyCallbacks(value: Type,
                               option: ObservableOptions) {
    let callbacksToNotify = callbacks.filter {
      $0.options.contains(option)
    }
    callbacksToNotify.forEach { $0.closure(value, option) }
  }
  
  // MARK: - Object Lifecycle
  public init(_ value: Type) {
    self.value = value
  }
  
  private var callbacks: [Callback] = []
  
  public func addObserver(
    _ observer: AnyObject,
    removeIfExists: Bool = true,
    options: [ObservableOptions] = [.new],
    closure: @escaping (Type, ObservableOptions) -> Void) {
    
    if removeIfExists {
      removeObserver(observer)
    }
    
    let callback = Callback(observer: observer,
                            options: options,
                            closure: closure)
    callbacks.append(callback)
    if options.contains(.initial) {
      closure(value, .initial)
    }
  }
  
  public func removeObserver(_ observer: AnyObject) {
    callbacks = callbacks.filter { $0.observer !== observer }
  }
}

// MARK: - ObservableOptions
public struct ObservableOptions: OptionSet {
  
  public static let initial =
    ObservableOptions(rawValue: 1 << 0)
  public static let old = ObservableOptions(rawValue: 1 << 1)
  public static let new = ObservableOptions(rawValue: 1 << 2)
  
  public var rawValue: Int
  
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
}
