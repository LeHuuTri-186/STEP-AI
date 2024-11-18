class Assistant {
  String? id;
  String model;
  String? name;
  String? logoPath;
  Assistant({
    this.id,
    required this.model,
    this.name,
    this.logoPath,
  });
  // factory Assistant.fromJson(Map<String, dynamic> json) {
  //   return Assistant(
  //     id: json['id'],
  //     model: json['model'],
  //     name: json['name'],
  //     logoPath: json['logoPath'],
  //   );
  // }
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'model': model,
  //     'name': name,
  //   };
  // }
}