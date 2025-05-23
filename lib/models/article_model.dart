class Article {
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? sourceName;
  final DateTime? publishedAt;

  Article({
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.sourceName,
    this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      sourceName: json['source'] != null ? json['source']['name'] : null,
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'sourceName': sourceName,
      'publishedAt': publishedAt?.toIso8601String(),
    };
  }
}
