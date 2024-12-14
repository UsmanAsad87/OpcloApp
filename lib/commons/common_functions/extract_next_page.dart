/// get Next Page.
String? extractNextPageLink(List<String>? links) {
  if (links == null || links.isEmpty) {
    return null;
  }
  final link = links.firstWhere(
        (element) => element.contains('rel="next"'),
    orElse: () => '',
  );
  final startIndex = link.indexOf('<');
  final endIndex = link.indexOf('>');
  if (startIndex != -1 && endIndex != -1) {
    return link.substring(startIndex + 1, endIndex);
  }
  return null;
}