import UIKit
import XCPlayground

let input = "k"
let reg = NSRegularExpression(pattern:"^\\s*$", options: nil, error: nil)
let matches = reg!.matchesInString(input, options: nil, range: NSMakeRange(0, count(input)))
matches
matches.count