class Dashboard {
  final String id;
  final String name;
  final String codename;
  final String link;

  Dashboard({
    required this.id,
    required this.name,
    required this.codename,
    required this.link,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'codename': codename,
      'link': link,
    };
  }

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      id: json['id'],
      name: json['name'],
      codename: json['codename'],
      link: json['link'],
    );
  }
}
