import 'package:flutter/material.dart';
import 'package:domgaleto/models/stores/store.dart';

class HomeCard extends StatelessWidget {
  const HomeCard(this.store);
  final Store store;
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          Text(
            store.statusText,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
