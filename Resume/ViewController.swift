//
//  ViewController.swift
//  Resume
//
//  Created by Ignacio Raul Silva on 8/17/19.
//  Copyright © 2019 SIRDISoft. All rights reserved.
//

import UIKit

let bgrColor     = UIColor(red: 48,  green: 63,  blue: 159)
let navColor     = UIColor(red: 63,  green: 81,  blue: 181)
let navTintColor = UIColor(red: 255, green: 255, blue: 255)
let titleColor   = UIColor(red: 255, green: 255, blue: 255)
let normalColor  = UIColor(red: 197, green: 202, blue: 233)

class ViewController: UIViewController
{
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor     = bgrColor

        textView.attributedText  = applyStyle(text: getResumeContent())
        textView.backgroundColor = .clear
        textView.isEditable      = false
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.barTintColor = navColor
        navigationController?.navigationBar.tintColor    = navTintColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : navTintColor]

        DispatchQueue.main.async {
            let desiredOffset = CGPoint(x: 0, y: -self.textView.contentInset.top)
            self.textView.setContentOffset(desiredOffset, animated: false)
        }
    }

    func getResumeContent() -> String
    {
        let filePath = Bundle.main.path(forResource: "resume", ofType: "txt")
        
        do {
            let data     = try Data(contentsOf: URL(fileURLWithPath: filePath!))
            let str      = String(decoding: data, as: UTF8.self)
            return str
        }
        catch
        {
            return "File Open Error: \(error.localizedDescription)"
        }
    }

    func applyStyle(text: String) -> NSAttributedString?
    {
        let attributedStringResulted = NSMutableAttributedString()

        //var substring  = text

        var startIndex = text.startIndex
        let endIndex   = text.endIndex

        repeat
        {
            let substring = text[startIndex..<endIndex]

            var nls = ""

            if let newLineRange = substring.index(of: "\n")
            {
                nls = String(substring[...newLineRange])
                startIndex = text.index(newLineRange, offsetBy: 1)
            }
            else
            {
                nls = String(substring)
            }

            var style:[NSAttributedString.Key: AnyObject] = [:]
            var lineToAdd = String(nls)

            if nls.hasPrefix("#####")
            {
                style = Theme.h5a
                lineToAdd = lineToAdd.replacingOccurrences(of: "#####", with: "")
            }
            else if nls.hasPrefix("####")
            {
                style = Theme.h4a
                lineToAdd = lineToAdd.replacingOccurrences(of: "####", with: "")
            }
            else if nls.hasPrefix("###")
            {
                style = Theme.h3a
                lineToAdd = lineToAdd.replacingOccurrences(of: "###", with: "")
            }
            else if nls.hasPrefix("##")
            {
                style = Theme.h2a
                lineToAdd = lineToAdd.replacingOccurrences(of: "##", with: "")
            }
            else if nls.hasPrefix("#")
            {
                style = Theme.h1a
                lineToAdd = lineToAdd.replacingOccurrences(of: "#", with: "")
            }
            else
            {
                style = Theme.pa
            }

            let stringAppend = NSMutableAttributedString(string: String(lineToAdd), attributes: style)
            attributedStringResulted.append(stringAppend)
        }
        while startIndex < endIndex

        return attributedStringResulted
    }
}

class Theme: NSObject
{
    // MARK: - Attributes

    static let h1a : [NSAttributedString.Key: AnyObject] = [
        .font: UIFont.h1!,
        .foregroundColor: titleColor,
    ]

    static let h2a : [NSAttributedString.Key: AnyObject] = [
        .font: UIFont.h3!,
        .foregroundColor: titleColor,
    ]

    static let h3a : [NSAttributedString.Key: AnyObject] = [
        .font: UIFont.h3!,
        .foregroundColor: titleColor,
    ]

    static let h4a : [NSAttributedString.Key: AnyObject] = [
        .font: UIFont.h4!,
        .foregroundColor: titleColor,
    ]

    static let h5a : [NSAttributedString.Key: AnyObject] = [
        .font: UIFont.h5!,
        .foregroundColor: titleColor,
    ]

    static let pa : [NSAttributedString.Key: AnyObject] = [
        .font: UIFont.h5!,
        .foregroundColor: normalColor,
    ]
}

// MARK: - Font Size

let fontMaxSize = 30
let fontMinSize = 14

func size(level: Int) -> CGFloat
{
    // 7 Sizes from fontMinSize to fontMaxSize
    return CGFloat(level) * ((CGFloat(fontMaxSize) - CGFloat(fontMinSize)) / CGFloat(7)) + CGFloat(fontMinSize)
}

extension UIFont
{
    static let h1 = UIFont (name: "HelveticaNeue-Bold", size: size(level: 7))
    static let h2 = UIFont (name: "HelveticaNeue-Bold", size: size(level: 5))
    static let h3 = UIFont (name: "HelveticaNeue-Bold", size: size(level: 3))
    static let h4 = UIFont (name: "HelveticaNeue-Bold", size: size(level: 1))
    static let h5 = UIFont (name: "HelveticaNeue-Bold", size: size(level: 0))

    static let p  = UIFont (name: "Avenir-Light", size: size(level: 0))
}


extension StringProtocol
{
    func nsRange(from range: Range<Index>) -> NSRange
    {
        return .init(range, in: self)
    }
}

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255

        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
