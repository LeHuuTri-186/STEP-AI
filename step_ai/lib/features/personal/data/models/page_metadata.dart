class PageMetadata{
  bool hasNext;
  double limit;
  double offset;
  double total;

  PageMetadata({
    required this.hasNext,
    required this.limit,
    required this.offset,
    required this.total,
  });

  factory PageMetadata.fromJson(Map<String, dynamic> json) {
    return PageMetadata(
      hasNext: json['hasNext'] as bool,
      limit: (json['limit'] as num).toDouble(),
      offset: (json['offset'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }
}