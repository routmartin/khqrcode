class TagLengthString {
  final String tag;
  final String value;
  final String length;

  TagLengthString(this.tag, this.value)
      : length = value.length < 10 
          ? '0${value.length}' 
          : value.length.toString();

  @override
  String toString() {
    return '$tag$length$value';
  }
}