import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:domgaleto/screens/products/category_screen.dart';

class CategoryListTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryListTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(
            snapshot["icon"],
          ),
        ),
        title: Text(
          snapshot["title"],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(Icons.keyboard_arrow_right_outlined),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CategoryScreen(snapshot)));
        },
      ),
    );
  }
}
