import 'package:flutter/material.dart';

import 'AchatPage.dart';

class DetailPage extends StatelessWidget {
  final Vetement vetement;

  const DetailPage({Key? key, required this.vetement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vetement.titre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(vetement.imageUrl),
            SizedBox(height: 16.0),
            Text(
              '${vetement.titre} - ${vetement.titre}',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '\$${vetement.prix.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              vetement.titre,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}