class CutStringResult {
  final String tag;
  final String value;
  final String slicedString;

  CutStringResult({
    required this.tag,
    required this.value,
    required this.slicedString,
  });
}

CutStringResult cutString(String input) {
  const int sliceIndex = 2;

  final String tag = input.substring(0, sliceIndex);
  final int length = int.parse(input.substring(sliceIndex, sliceIndex * 2));
  final String value = input.substring(sliceIndex * 2, sliceIndex * 2 + length);
  final String slicedString = input.substring(sliceIndex * 2 + length);

  return CutStringResult(
    tag: tag,
    value: value,
    slicedString: slicedString,
  );
}