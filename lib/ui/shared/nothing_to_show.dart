import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class NothingToShow extends StatelessWidget {
  final String nothingText;
  const NothingToShow({Key? key, required this.nothingText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "¯\\_(ツ)_/¯",
              style: TextStyle(fontSize: 30.0),
            ),
          ),
          Text(nothingText),
        ],
      ),
    );
  }
}
