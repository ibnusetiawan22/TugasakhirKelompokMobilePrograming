class ModelDoa {
  String? name;
  String? arabic;
  String? latin;
  String? terjemahan;

  ModelDoa({this.name, this.arabic, this.latin, this.terjemahan});

  factory ModelDoa.fromJson(Map<String, dynamic> json) {
    return ModelDoa(
      name: json['name'] as String?,
      arabic: json['arabic'] as String?,
      latin: json['latin'] as String?,
      terjemahan: json['terjemahan'] as String?,
    );
  }
}
