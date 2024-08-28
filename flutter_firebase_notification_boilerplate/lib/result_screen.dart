import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final dynamic data;

  const ResultScreen({Key key, this.data}) : super(key: key);
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Screen'),
      ),
      body: Center(
        child: Text('${widget.data.toString()}'),
      ),
    );
  }
}
