import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:freshology/constants/styles.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:nanoid/url.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfViewerPage extends StatefulWidget {
  final String url;
  const PdfViewerPage({Key key, this.url}) : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  PDFDocument doc;
  bool _isLoading = false;
  void loadPdf() async {
    setState(() {
      _isLoading = true;
    });
    doc = await PDFDocument.fromURL(widget.url);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      loadPdf();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
        backgroundColor: kLightGreen,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              print(widget.url);
              if (await canLaunch(widget.url)) {
                await launch(widget.url);
              } else {
                throw 'Could not launch ${widget.url}';
              }
            },
            icon: Icon(
              Icons.cloud_download,
              color: Colors.white,
            ),
            label: Text(
              'Download',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Container(
          child: _isLoading ? Container() : PDFViewer(document: doc),
        ),
      ),
    );
  }
}
