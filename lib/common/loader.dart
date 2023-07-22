import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  Future<void> showLoadingDialog(BuildContext context) async {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return const CupertinoAlertDialog(
          title: Text('Loading'),
          content: CupertinoActivityIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Since this is just a loader widget, it does not need to return anything
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(
          height: 10,
        ),
        Text('Fetching data please wait')
      ],
    );
  }
}
