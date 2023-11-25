import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListaPedidosView extends StatefulWidget {
  @override
  _ListaPedidosViewState createState() => _ListaPedidosViewState();
}

class _ListaPedidosViewState extends State<ListaPedidosView> {
  List<Pedido> pedidos = [];

  @override
  void initState() {
    super.initState();
    cargarPedidos();
  }

  void cargarPedidos() async {
    final response = await http.get(Uri.parse(
        "https://apisublimarce.onrender.com/pedido")); // Reemplaza con la URL correcta de tu API

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      for (final item in data) {
        final pedido = Pedido.fromJson(item);
        pedidos.add(pedido);
      }

      setState(() {});
    } else {
      print('Error al cargar los pedidos: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: pedidos.length,
        itemBuilder: (context, index) {
          final pedido = pedidos[index];
          return Card(
            child: ListTile(
              title: Text('Pedido #${pedido.id}'),
              subtitle: Text(
                  'Cantidad: ${pedido.cantidad}, Precio: \$${pedido.precio.toStringAsFixed(2)}, Estado: ${pedido.status}'),
              onTap: () {
                // Navegar a la vista de detalles del pedido
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetallesPedidoView(pedido: pedido),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class Pedido {
  final int id;
  final int idCamisasBordadas;
  final int idProductos;
  final int cantidad;
  final double precio;
  final String status;
  final int idCliente;

  Pedido(this.id, this.idCamisasBordadas, this.idProductos, this.cantidad,
      this.precio, this.status, this.idCliente);

  // Constructor para convertir un mapa a un objeto Pedido
  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      json['ID-PEDIDOS'],
      json['ID-CAMISAS BORDADAS'],
      json['ID-PRODUCTOS'],
      json['CANTIDAD'],
      json['PRECIO'].toDouble(),
      json['STATUS'],
      json['ID-CLIENTE'],
    );
  }
}

class DetallesPedidoView extends StatelessWidget {
  final Pedido pedido;

  DetallesPedidoView({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Pedido'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Número de Pedido: ${pedido.id}'),
            Text('Cantidad: ${pedido.cantidad}'),
            Text('Precio: \$${pedido.precio.toStringAsFixed(2)}'),
            Text('Estado: ${pedido.status}'),
            // Agrega más detalles según sea necesario
          ],
        ),
      ),
    );
  }
}