class Book {
  String _title;
  double _price;
  int _authorid;
  String _date;

  // Constructor
  Book({
    required String title,
    required double price,
    required int authorid,
    required String date,
  })  : _title = title,
        _price = price,
        _authorid = authorid,
        _date = date;

  // Empty constructor
  Book.empty()
      : _title = '',
        _price = 0.0,
        _authorid = 0,
        _date = '';

  // Getters and setters
  String get title => _title;
  set title(String title) => _title = title;

  double get price => _price;
  set price(double price) => _price = price;

  int get authorid => _authorid;
  set authorid(int authorid) => _authorid = authorid;

  String get date => _date;
  set date(String date) => _date = date;

  // Factory method to create a Book from a map
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      authorid: map['author_id'],
      title: map['title'],
      price: map['price'],
      date: map['created_at'],
    );
  }

  // Method to convert a Book to a map
  Map<String, dynamic> toMap() {
    return {
      'author_id': _authorid,
      'title': _title,
      'price': _price,
      'created_at': _date,
    };
  }
}