import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshology/constants/styles.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Terms extends StatefulWidget {
  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  String fileText = '';
  bool _isLoading = false;

  void loadText() async {
    setState(() {
      _isLoading = true;
    });
    String fetchedText = await rootBundle.loadString('assets/terms.txt');
    setState(() {
      fileText = fetchedText;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    loadText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightGreen,
        title: Text('Terms and Conditions'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 15,
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Text(
                  fileText,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
