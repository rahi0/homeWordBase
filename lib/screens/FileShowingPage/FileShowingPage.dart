import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:homewardbase/api/api.dart';




////////////////////// Full Screen Image End //////////////////////


class FullScreenImage extends StatelessWidget {
  final imageUrl;
 FullScreenImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Hero(
              tag: "$imageUrl",
              child: Image.network(
                     CallApi().fileShowlurl +'$imageUrl',
                     fit: BoxFit.contain,
                     loadingBuilder: (context, child, progress){
                       return progress == null ?
                      child : LinearProgressIndicator();
                      },
                   ),
            ),
          ),
        ),
        
      ),
    );
  }
}

////////////////////// Full Screen Image End //////////////////////

///not using this one///
/////////////////////////////// Pdf Screen Start ////////////////////////////////

class PdfScreen extends StatefulWidget {
final docUrl;
PdfScreen(this.docUrl);
  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  bool _isLoading = true;
  PDFDocument doc;


  @override
  void initState() {
    _loadFromUrl();
    print("http://10.0.2.2:8000"+"${widget.docUrl}");
    super.initState();
  }

  // void _loadFromAssets() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   doc = await PDFDocument.fromAsset('assets/sample.pdf');
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  void _loadFromUrl() async {
    setState(() {
      _isLoading = true;
    });
    doc = await PDFDocument.fromURL(
        "http://10.0.2.2:8000"+"${widget.docUrl}");
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : PDFViewer(
                document: doc,
                showPicker: false,
              ),
      ),
    );
  }
}
/////////////////////////////// Pdf Screen  End////////////////////////////////