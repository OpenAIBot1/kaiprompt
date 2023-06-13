import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key, this.loadingText}) : super(key: key);

  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: LinearProgressIndicator()),
          Text(loadingText ?? "Loading..."),
        ],
      ),
    );
  }
}
