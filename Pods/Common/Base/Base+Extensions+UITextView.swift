import UIKit

public extension UITextView {
    /// number of lines based on entered text
    public var numberOfLines: Int {
        guard compare(beginningOfDocument, to: endOfDocument).same == false else {
            return 0
        }
        let direction: UITextDirection = UITextStorageDirection.forward.rawValue
        var lineBeginning = beginningOfDocument
        var lines = 0
        while true {
            lines += 1
            guard let lineEnd = tokenizer.position(from: lineBeginning, toBoundary: .line, inDirection: direction) else {
                fatalError()
            }
            guard compare(lineEnd, to: endOfDocument).same == false else {
                break
            }
            guard let newLineBeginning = tokenizer.position(from: lineEnd, toBoundary: .character, inDirection: direction) else {
                fatalError()
            }
            guard compare(newLineBeginning, to: endOfDocument).same == false else {
                return lines + 1
            }
            lineBeginning = newLineBeginning
        }
        return lines
    }
    /// Количество строк, где 0 считается за 1
    public var numberOfLinesNonZero: Int {
        let numberOfLines = self.numberOfLines
        return numberOfLines > 0 ? numberOfLines : 1
    }
    ///
    public var cursorAtLine: Int? {
        guard let selectionEnd = selectedTextRange?.end, let selectionStart = selectedTextRange?.start  else {
            return nil
        }
        guard compare(selectionEnd, to: selectionStart).same == true else {
            return nil
        }
        guard compare(beginningOfDocument, to: selectionEnd).same == false else {
            return 0
        }
        let direction: UITextDirection = UITextStorageDirection.forward.rawValue
        var lineBeginning = beginningOfDocument
        var line = 0
        while true {
            guard let lineEnd = tokenizer.position(from: lineBeginning, toBoundary: .line, inDirection: direction) else {
                fatalError()
            }
            guard compare(lineEnd, to: selectionEnd).descending == false else {
                break
            }
            guard compare(lineEnd, to: endOfDocument).same == false else {
                break
            }
            guard let newLineBeginning = tokenizer.position(from: lineEnd, toBoundary: .character, inDirection: direction) else {
                fatalError()
            }
            guard compare(newLineBeginning, to: selectionEnd).same == false else {
                line += 1
                break
            }
            guard compare(newLineBeginning, to: endOfDocument).same == false else {
                line += 1
                break
            }
            lineBeginning = newLineBeginning
            line += 1
        }
        return line
    }
    
    var cursorAtEnd: Bool? {
        guard let line = cursorAtLine else {
            return nil
        }
        let lines = numberOfLines
        guard lines > 0 else {
            return true
        }
        return line - 1 == numberOfLines
    }
}
