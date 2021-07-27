extension UriExtensions on Uri {
  List<String> get nonEmptyPathSegments =>
    this.pathSegments.where((pathSegment) => pathSegment.isNotEmpty).toList();
}