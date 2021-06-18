import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class PluisPdfViewer extends StatefulWidget {
  final String url;

  const PluisPdfViewer({Key key, this.url}) : super(key: key);

  @override
  _PluisPdfViewer createState() => _PluisPdfViewer(url);
}

class _PluisPdfViewer extends State<PluisPdfViewer> {
  final String url;
  bool _isLoading = true;
  PDFDocument document;

  _PluisPdfViewer(this.url);

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    setState(() => _isLoading = true);

    document = await PDFDocument.fromURL(
      url,
      /* cacheManager: CacheManager(
          Config(
            "customCacheKey",
            stalePeriod: const Duration(days: 2),
            maxNrOfCacheObjects: 10,
          ),
        ), */
    );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min,children: [
      buildAppBar(),
      _isLoading
          ? Center(child: CircularProgressIndicator())
          : Flexible(
              child: Container(
                child: PDFViewer(
                  showIndicator: false,
                  showNavigation: false,
                  showPicker: false,
                  document: document,
                  zoomSteps: 1,
                  //uncomment below line to preload all pages
                  // lazyLoad: false,
                  // uncomment below line to scroll vertically
                  // scrollDirection: Axis.vertical,

                  //uncomment below code to replace bottom navigation with your own
                  /* navigationBuilder:
                          (context, page, totalPages, jumpToPage, animateToPage) {
                        return ButtonBar(
                          alignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.first_page),
                              onPressed: () {
                                jumpToPage()(page: 0);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                animateToPage(page: page - 2);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () {
                                animateToPage(page: page);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.last_page),
                              onPressed: () {
                                jumpToPage(page: totalPages - 1);
                              },
                            ),
                          ],
                        );
                      }, */
                ),
              ),
            ),
    ]);
  }

  AppBar buildAppBar() => AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () => {Navigator.of(context).pop()},
        ),
      );
}
