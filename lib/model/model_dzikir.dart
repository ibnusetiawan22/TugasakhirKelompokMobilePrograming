class ModelDzikir {
  String? name;
  String? arabic;
  String? terjemahan; // Tambahkan atribut terjemahan

  ModelDzikir({this.name, this.arabic, this.terjemahan});

  factory ModelDzikir.fromJson(Map<String, dynamic> json) {
    return ModelDzikir(
      name: json['name'] as String?,
      arabic: json['arabic'] as String?,
      terjemahan: json['terjemahan']
          as String?, // Ubah sesuai dengan nama field di JSON
    );
  }
}
