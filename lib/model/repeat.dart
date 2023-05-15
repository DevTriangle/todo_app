class Repeat {
  final String name;
  final String type;

  Repeat(this.name, this.type);

  factory Repeat.fromJson(Map<String, dynamic> json) {
    return Repeat(
      json['name'],
      json['type'],
    );
  }

  Map toJson() => {
        'name': name,
        'type': type,
      };
}
