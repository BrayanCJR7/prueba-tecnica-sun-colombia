import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:prueba_tecnica_sun_colombia/globals.dart';
import 'package:prueba_tecnica_sun_colombia/models/grupo.dart';
import 'package:prueba_tecnica_sun_colombia/pages/InfoGruposPage.dart';

class GruposPage extends StatefulWidget {
  final String? CodSede;

  const GruposPage({super.key, required this.CodSede});

  @override
  State<GruposPage> createState() => _GruposPageState();
}

class _GruposPageState extends State<GruposPage> {

  Future<List<Grupo>> getGrupos() async {
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'User': user,
          'Password': Password,
          'option': option_grupos,
          'CodSede': widget.CodSede
        }));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['login'] == 'Success') {
        final gruposData = data['data'] as List<dynamic>;
        print("lo de la api opcion grupo $gruposData");
        return gruposData
            .map((gruposData) => Grupo.fromJson(gruposData))
            .toList();
      } else {
        throw Exception('Error al obtener los grupos: ${data['data']}');
      }
    } else {
      throw Exception('Error de red: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    getGrupos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grupos"),
      ),
      body: Center(
        child: Container(
          child: FutureBuilder<List<Grupo>>(
            future: getGrupos(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final grupos = snapshot.data!;
                return ListView.builder(
                    itemCount: grupos.length,
                    itemBuilder: (context, index) {
                      final grupo = grupos[index];
                      return ListTile(
                        title: Text(grupo.grupo),
                        subtitle: Text('N° Grupo: ${grupo.num_grupo}'),
                        onTap: () async{
                          final idGrupo = grupo.id;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InfoGruposPage(IdGrupo: idGrupo),
                            ),
                          );
                        },
                      );
                    });
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
