

class Link {
  late String title;
  late String url;

  Link({required this.title, required this.url});

  Link.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    url = json["url"];
  }

  Map<String, String> toJson() => {
    "title": title,
    "url": url
  };

  static List<Link>? fromJsonList(dynamic links) {
    return (links as List?)?.map((link) => Link.fromJson(link)).toList();
  }

  static List<Map<String, String>>? toJsonList(List<Link>? links) {
    return links?.map((Link link) => link.toJson()).toList();
  }
}