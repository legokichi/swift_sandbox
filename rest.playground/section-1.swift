import UIKit
import XCPlayground

func get(url: String, callback: (NSError!, String!) -> Void) -> Void {
    var req = NSMutableURLRequest()
    req.URL = NSURL(string: url)
    req.HTTPMethod = "GET"
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: config)
    var task = session.dataTaskWithRequest(
        req,
        completionHandler: {(data:NSData!, resp:NSURLResponse!, err:NSError!)-> Void in
            if (err != nil) {
                callback(err, nil)
                return
            }
            callback(nil, NSString(data: data, encoding: NSUTF8StringEncoding))
        }
    )
    task.resume()
}


func post(url: String, params:[(String, String, NSData)], callback: (NSError!, String!) -> Void) -> Void {
    var req = NSMutableURLRequest()
    req.URL = NSURL(string: url)
    req.HTTPMethod = "POST"
    let boundary = "----teamApple" + String(arc4random() % 10000000)
    req.setValue("multipart/form-data; charaset=utf-8; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    let body = NSMutableData()
    for (key, type, val) in params {
        let headStr = [
            "--\(boundary)",
            "Content-Disposition: form-data; name=\"\(key)\";",
            "Content-Type: \(type)",
            ""
            ].reduce("", {(sum, str) in sum + str + "\r\n" })
        body.appendData(headStr.dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(val)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    }
    body.appendData("--\(boundary)--".dataUsingEncoding(NSUTF8StringEncoding)!)
    req.setValue(String(body.length), forHTTPHeaderField: "Content-Length")
    req.HTTPBody = body
    
    println(req.allHTTPHeaderFields)
    println(NSString(data:body, encoding:NSUTF8StringEncoding)!)
    
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: config)
    var task = session.dataTaskWithRequest(
        req,
        completionHandler: {(data:NSData!, resp:NSURLResponse!, err:NSError!)-> Void in
            if (err != nil) {
                callback(err, nil)
                return
            }
            callback(nil, NSString(data: data, encoding: NSUTF8StringEncoding))
        }
    )
    task.resume()
}