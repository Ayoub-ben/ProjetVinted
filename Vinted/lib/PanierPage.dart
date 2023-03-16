import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'AchatPage.dart';

class PanierPage extends StatefulWidget {
  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  List<Vetement> _panier = [];

  @override
  void initState() {
    super.initState();
    _getPanierFromFirestore();
  }

  void _getPanierFromFirestore() async {
    var firestore = FirebaseFirestore.instance;
    var collection = firestore.collection('panier');
    var snapshot = await collection.get();
    setState(() {
      _panier = snapshot.docs.map((doc) => Vetement.fromSnapshot(doc)).toList();
    });
  }

  void _deleteVetementFromPanier(int index) async {
    var firestore = FirebaseFirestore.instance;
    var collection = firestore.collection('panier');
    await collection.doc(_panier[index].id).delete();
    setState(() {
      _panier.removeAt(index);
    });
  }

  double _getTotalPrix() {
    double total = 0;
    for (var i = 0; i < _panier.length; i++) {
      total += _panier[i].prix;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
      ),
      body: _panier.isEmpty
          ? Center(
        child: Text('Le panier est vide.'),
      )
          : ListView.builder(
        itemCount: _panier.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Image.network(_panier[index].imageUrl),
            title: Text(_panier[index].titre),
            subtitle:
            Text('\$${_panier[index].prix.toStringAsFixed(2)}'),
            trailing: IconButton(
              onPressed: () {
                _deleteVetementFromPanier(index);
              },
              icon: Icon(Icons.delete),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Total: \$${_getTotalPrix().toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Payer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
