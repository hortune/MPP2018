
public extension BookStore {

    public static func from(_ books: [[String: String]]) -> BookStore {
        let bookStore = BookStore()

        func getBook(bookIndex: Int) -> Book?{
            // Implement 'getBook' method
            
            guard bookIndex < books.count else {
                return nil
            }
            
            if let title = books[bookIndex]["title"],
                let author = books[bookIndex]["author"],
                let price = Double(books[bookIndex]["price"]!){
                return Book(title : title,
                            author : author,
                            price : price)
            } else{
                return nil
            }
        }
        
        // Get books to buy
        bookStore.setDataSource(bookGetter: getBook)

        return bookStore
    }
}
