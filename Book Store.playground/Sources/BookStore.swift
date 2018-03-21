import PlaygroundSupport

// MARK: - Book
public struct Book{
    var title: String
    var author: String
    var price: Double
}

// MARK: - Book Store (Model and Main class)

public class BookStore {

    public init() {}
    
    // MARK: Properties

    var books: [Book] = []
    
    var totalBookPrice: Double = 0
    
    var authors: [String] = []
    // MARK: Function interfacesc

    public func setDataSource(bookGetter: ((Int) -> Book?)) {
        var books = [Book]()
        var totalBookPrice = 0.0
        var authors: [String] = []
        
        // Get book from bookGetter
        var index: Int = 0
        while let book = bookGetter(index) {
            books.append(book)
            totalBookPrice += book.price
            authors.append(book.author)
            index += 1
            print(index)
        }
        
        print(authors)
        print(totalBookPrice)
        // Sort books
        
        // Retrieive authors and prices
    
        //assign value to property
        self.books = books
        self.totalBookPrice = totalBookPrice
        self.authors = authors
        
    }

}


