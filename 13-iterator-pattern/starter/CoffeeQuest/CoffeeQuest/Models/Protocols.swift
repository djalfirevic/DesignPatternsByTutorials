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

import Foundation
import MapKit
import YelpAPI

protocol SearchResultsProtocol {
  func adaptSearchResultsFromYLP() -> SearchResults
}

protocol BusinessProtocol {
  func adaptBusinessFromYLP() -> Business
}

public struct SearchResults {
  var businesses: [Business]
  var total: UInt
}

public struct Business {
  var name: String
  var rating: Double
  var location: CLLocationCoordinate2D
}

extension YLPLocation {

  func getCoordinateFromYLP() -> CLLocationCoordinate2D {
    return CLLocationCoordinate2DMake(self.coordinate!.latitude,
                                      self.coordinate!.longitude)
  }
}

extension YLPBusiness: BusinessProtocol {

  func adaptBusinessFromYLP() -> Business {
    return Business(name: self.name,
                    rating: self.rating,
                    location: self.location.getCoordinateFromYLP())
  }
}

extension YLPSearch: SearchResultsProtocol {

  func adaptSearchResultsFromYLP() -> SearchResults {
    let businesses = self.businesses
      .map { (business: YLPBusiness) in
        business.adaptBusinessFromYLP()
      }

    return SearchResults(businesses: businesses,
                         total: self.total)
  }
}
