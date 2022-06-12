import 'package:flutter/material.dart';

class NetworkError extends StatelessWidget {
  final VoidCallback refresh;
  const NetworkError({Key? key, required this.refresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
              child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Text("An Error occured while loading this feed"),
          )),
          Center(
            child: ElevatedButton(
              onPressed: () {
                refresh();
              },
              child: const Text('Refresh'),
            ),
          )
        ],
      ),
    );
  }
}
