class Grupo {
  final String id;
  final String grupo;
  final String num_grupo;

  Grupo.fromJson(Map<String, dynamic> json)
      : id = json['id'] != null ? json['id'] as String : '',
        grupo = json['nombre'] != null ? json['nombre'] as String : '',
        num_grupo = json['numGrupo'] != null ? json['numGrupo'] as String : '';
}
