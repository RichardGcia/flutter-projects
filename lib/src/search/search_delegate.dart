import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';

  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'spiderman',
    'capitan america',
    'shazam',
    'batman',
    'avengers',
    'rogue',
    'bob esponja',
    'overwatch',
  ];
  final peliculasRecientes = [
    'spiderman',
    'capitan america',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones del AppBar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Instruccion que crea los resultados que se van a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((pelicula) {
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10.00),
                  child: FadeInImage(
                    image: NetworkImage(pelicula.getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 40.0,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () {
                  close(context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    // Sugerencias que aparecen cuando la persona escribe
    //Codigo de referencia

    // final listaSugerida = (query.isEmpty)
    //     ? peliculasRecientes
    //     : peliculas.where((p) => p.toLowerCase().startsWith(query)).toList();

    // return ListView.builder(
    //   itemCount: listaSugerida.length,
    //   itemBuilder: (context, i) {
    //     return ListTile(
    //       leading: Icon(Icons.movie),
    //       title: Text(listaSugerida[i]),
    //       onTap: () {
    //         seleccion = listaSugerida[i];
    //       },
    //     );
    //   },
    // );
  }
}
