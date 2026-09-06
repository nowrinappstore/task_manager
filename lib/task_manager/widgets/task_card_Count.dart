import 'package:flutter/material.dart';

class TaxCardCount extends StatelessWidget {

  final String title;
  final int count;

  const TaxCardCount({
    super.key, required this.title, required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        child: Column(
          children: [
            Text(count.toString(),style: Theme.of(context).textTheme.titleLarge,),
            Text(title),
          ],
        ),
      ),
    );
  }
}