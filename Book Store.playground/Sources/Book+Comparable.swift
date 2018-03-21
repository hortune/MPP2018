import Foundation

extension BookStore {
    
    func sortAuthors(_ authors: [String]) -> [String] {
        let locale = Locale(identifier: "zh_TW")
        return authors.sorted(by: {$0.compare($1,locale: locale) == .orderedAscending})
    }
    
    func sortBooks(_ books: [Book]) -> [Book] {
        let locale = Locale(identifier: "zh_TW")
        return books.sorted(by: {$0.title.compare($1.title,locale: locale) == .orderedAscending})
    }
}
