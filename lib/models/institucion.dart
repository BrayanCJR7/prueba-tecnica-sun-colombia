class Institucion {
  final String institucion;
  final String dane_institucion;

  Institucion.fromJson(Map<String, dynamic> json)
      : institucion = json['nombre'] != null ? json['nombre'] as String : '',
        dane_institucion = json['dane'] != null ? json['dane'] as String : '';
}