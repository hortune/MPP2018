import Foundation

extension BookStore {
//    
    func sortAuthors(_ authors: [String]) -> [String] {
        let locale = Locale(identifier: "zh_TW")
        return authors.sorted(by: {$0.compare($1,locale: locale) == .orderedAscending})
    }
//    
//    func sortBooks(_ books: [Book]) -> [Book] {
//        let locale = Locale(identifier: "zh_TW")
//        return books.sorted(by: {$0.title.compare($1.title,locale: locale) == .orderedAscending})
//    }
}


extension Book: Comparable {
    public static func == (lhs: Book, rhs: Book) -> Bool {
        let locale = Locale(identifier: "zh_TW")
        if lhs.title.compare(rhs.title,locale : locale) == ComparisonResult.orderedSame &&
            lhs.author.compare(rhs.author,locale : locale) == ComparisonResult.orderedSame &&
            lhs.price == rhs.price{
            return true
        }
        return false
    }

    public static func < (lhs: Book, rhs: Book) -> Bool {
        let locale = Locale(identifier: "zh_TW")
        if lhs.title.compare(rhs.title,locale : locale) == ComparisonResult.orderedAscending{
            return true
        }
        else if lhs.title.compare(rhs.title,locale : locale) == ComparisonResult.orderedDescending{
            return false
        }
        else if lhs.author.compare(rhs.author,locale : locale) == ComparisonResult.orderedAscending{
            return true
        }
        else if lhs.author.compare(rhs.author,locale : locale) == ComparisonResult.orderedDescending{
            return false
        }
        else{
            return lhs.price < rhs.price
        }
        
        
    }
}
