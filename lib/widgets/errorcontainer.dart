import 'package:flutter/material.dart';

class ErrorContainer extends StatelessWidget {
  final String error;

  const ErrorContainer(this.error, {super.key});

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          color: Colors.red[800],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 5, color: Colors.redAccent)),
      child: Center(
          child: Text(
        error.toString(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
        textAlign: TextAlign.center,
      )));
}
