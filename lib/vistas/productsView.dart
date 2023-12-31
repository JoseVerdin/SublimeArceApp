import 'package:flutter/material.dart';
import 'cartView.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ejercicio1/bd/producto.dart';

class productsView extends StatefulWidget {
  static String tag = "productsView";

  @override
  _productsViewState createState() => _productsViewState();
}

class _productsViewState extends State<productsView> {
  List<Producto> camisas = [];
  List<Producto> bolsas = [];
  List<Producto> tazas = [];

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  void cargarProductos() async {
    final response = await http
        .get(Uri.parse('https://apisublimarce.onrender.com/getproductos'));
    //final response = await http.get(Uri.parse('http://localhost:3000/getproductos'));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      //print(data);
      // Llena las listas de productos según la categoría.
      for (final item in data) {
        final producto = Producto.fromJson(item);
        if (producto.categoria == 'CAMISAS') {
          camisas.add(producto);
        } else if (producto.categoria == 'BOLSAS') {
          bolsas.add(producto);
        } else if (producto.categoria == 'TAZAS') {
          tazas.add(producto);
        }
      }
      print('------------CAMISAS------------');
      camisas.forEach((producto) {
        print('ID: ${producto.id}, Categoria: ${producto.categoria}');
      });
      print('----------------BOLSAS---------------');
      bolsas.forEach((producto) {
        print('ID: ${producto.id}, Categoria: ${producto.categoria}');
      });
      print('----------------TAZAS---------------');
      tazas.forEach((producto) {
        print('ID: ${producto.id}, Categoria: ${producto.categoria}');
      });

      setState(() {
        // No es necesario actualizar 'products' ya que ahora estás usando listas separadas.
      });
    } else {
      print('Error al cargar productos: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Regresar a la página anterior
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartView(),
                  ),
                );
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ],
          title: Text('Productos'),
          centerTitle: true,
          backgroundColor: Colors.purple,
          bottom: TabBar(
            tabs: <Widget>[
              new Tab(
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Text('CAMISAS'),
                ),
              ),
              new Tab(
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Text('TAZAS'),
                ),
              ),
              new Tab(
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Text('BOLSAS'),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: camisas
                    .map((product) => Producto(
                        product.id,
                        product.nombre,
                        product.imagen,
                        product.descripcion,
                        product.precio.toDouble(),
                        product.categoria,
                        product.stock))
                    .toList(),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: tazas
                    .map((product) => Producto(
                        product.id,
                        product.nombre,
                        product.imagen,
                        product.descripcion,
                        product.precio.toDouble(),
                        product.categoria,
                        product.stock))
                    .toList(),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: bolsas
                    .map((product) => Producto(
                        product.id,
                        product.nombre,
                        product.imagen,
                        product.descripcion,
                        product.precio.toDouble(),
                        product.categoria,
                        product.stock))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
