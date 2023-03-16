import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'DetailPage.dart';
import 'PanierPage.dart';
import 'ProfilPage.dart';

List<Vetement> panier = [];

class AchatPage extends StatefulWidget {
  @override
  _AchatPageState createState() => _AchatPageState();
}

class _AchatPageState extends State<AchatPage> with TickerProviderStateMixin{
  late TabController _tabController;
  late List<Vetement> _vetements;
  late List<Vetement> _chemises;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _vetements = [];
    _chemises = [];
    FirebaseFirestore.instance
        .collection('vetement')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Vetement vetement = Vetement.fromSnapshot(doc);
        _vetements.add(vetement);
        if (vetement.categorie == 'Chemise') {
          _chemises.add(vetement);
        }
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vêtements'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Tous'),
            Tab(text: 'Chemises'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(_vetements),
          _buildList(_chemises),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Acheter'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Panier'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (int index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PanierPage()),
            );
          }
          else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildList(List<Vetement> vetements) {
    if (vetements.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: vetements.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(vetement: vetements[index]),
              ),
            );
          },
          child: ListTile(
            leading: Image.network(vetements[index].imageUrl),
            title: Text(vetements[index].titre),
            subtitle: Text('\$${vetements[index].prix.toStringAsFixed(2)}'),
            trailing: ElevatedButton(
                onPressed: () {
                  panier.add(vetements[index]);

                  FirebaseFirestore.instance.collection('panier').add({
                    'titre': vetements[index].titre,
                    'imageUrl': vetements[index].imageUrl,
                    'prix': vetements[index].prix,
                    'categorie': vetements[index].categorie,
                    'id': vetements[index].id,
                  });
                },
              child: Text('Ajouter au panier'),
            ),
          ),
        );
      },
    );
  }
}


class Vetement {
  final String id;
  final String titre;
  final String imageUrl;
  final int prix;
  final String categorie;


  Vetement({
    required this.id,
    required this.titre,
    required this.imageUrl,
    required this.prix,
    required this.categorie,
  });

  factory Vetement.fromSnapshot(DocumentSnapshot snapshot) {
    return Vetement(
      id: snapshot.id,
      titre: snapshot['titre'],
      imageUrl: snapshot['imageUrl'],
      prix: snapshot['prix'],
      categorie: snapshot['categorie'],
    );
  }
}
