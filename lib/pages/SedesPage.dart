import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prueba_tecnica_sun_colombia/globals.dart';
import 'package:prueba_tecnica_sun_colombia/models/sede.dart';


import 'package:http/http.dart' as http;
import 'package:prueba_tecnica_sun_colombia/pages/GruposPage.dart';

class SedesPage extends StatefulWidget {

  final String? CodInst;

  const SedesPage({super.key, required this.CodInst});

  @override
  State<SedesPage> createState() => _SedesPageState();
}

class _SedesPageState extends State<SedesPage> {

  Future<List<Sede>> getSedes() async {
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'User': user,
          'Password': Password,
          'option': option_sedes,
          'CodInst': widget.CodInst
        }));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['login'] == 'Success') {
        final institucionData = data['data'] as List<dynamic>;
        return institucionData
            .map((institucionData) => Sede.fromJson(institucionData))
            .toList();
      } else {
        throw Exception('Error al obtener municipios: ${data['data']}');
      }
    } else {
      throw Exception('Error de red: ${response.statusCode}');
    }
  }
  @override
  void initState() {
    super.initState();
    getSedes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sedes"),
      ),
      body: Center(
        child: Container(
          child: FutureBuilder<List<Sede>>(
            future: getSedes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final instituciones = snapshot.data!;
                return ListView.builder(
                    itemCount: instituciones.length,
                    itemBuilder: (context, index) {
                      final institucion = instituciones[index];
                      return ListTile(
                        title: Text(institucion.sede),
                        subtitle: Text('DANE: ${institucion.dane_sede}'),
                        onTap: () async{
                          final dane = institucion.dane_sede;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GruposPage(CodSede: dane),
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
