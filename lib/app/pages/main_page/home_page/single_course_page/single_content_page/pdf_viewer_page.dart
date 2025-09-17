import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/data/app_data.dart';

class PdfViewerPage extends StatefulWidget {
  static const String pageName = '/pdf-viewer';
  final String? pdfUrl;

  const PdfViewerPage({Key? key, this.pdfUrl}) : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? title;
  String? path;
  late String name;
  bool isNetworkFile = false;
  bool isLoading = false;

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController pdfViewerController = PdfViewerController();

  @override
  void initState() {
    super.initState();
    getUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is List) {
        path = args[0];
        title = args[1];
        _loadPdf();
      } else if (widget.pdfUrl != null) {
        path = widget.pdfUrl;
        title = "PDF Viewer";
        _loadPdf();
      }
    });
  }

  Future<void> getUser() async {
    name = await AppData.getName();
  }

  void _loadPdf() async {
    if (path == null) return;
    if (path!.startsWith("http")) {
      isNetworkFile = true;
    }
    setState(() {});
    pdfViewerController.zoomLevel = 1.5;
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<void> downloadAndOpenPdf() async {
    if (await requestStoragePermission()) {
      try {
        setState(() => isLoading = true);

        final directory = await getApplicationDocumentsDirectory();
        String savePath = "${directory.path}/downloaded.pdf";

        var dio = Dio();
        await dio.download(widget.pdfUrl!, savePath);

        setState(() {
          path = savePath;
          isNetworkFile = false;
          isLoading = false;
        });

        pdfViewerController.zoomLevel = 1.5;
      } catch (e) {
        print("❌ Error downloading file: $e");
        setState(() => isLoading = false);
      }
    } else {
      print("❌ Storage permission denied.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return directionality(
      child: Scaffold(
        appBar: appbar(title: title ?? 'PDF'),
        floatingActionButton: path != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: 'zoom_in',
                    onPressed: () {
                      setState(() {
                        pdfViewerController.zoomLevel += 0.25;
                      });
                    },
                    child: const Icon(Icons.zoom_in),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: 'zoom_out',
                    onPressed: () {
                      setState(() {
                        if (pdfViewerController.zoomLevel > 1.0) {
                          pdfViewerController.zoomLevel -= 0.25;
                        }
                      });
                    },
                    child: const Icon(Icons.zoom_out),
                  ),
                ],
              )
            : null,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : path != null
                ? Stack(
                    children: [
                      isNetworkFile
                          ? SfPdfViewer.network(
                              path!,
                              key: _pdfViewerKey,
                              controller: pdfViewerController,
                            )
                          : SfPdfViewer.file(
                              File(path!),
                              key: _pdfViewerKey,
                              controller: pdfViewerController,
                            ),
                      Center(
                        child: Opacity(
                          opacity: 0.2,
                          child: Transform.rotate(
                            angle: -0.3,
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: ElevatedButton(
                      onPressed: downloadAndOpenPdf,
                      child: const Text("Download and Open PDF"),
                    ),
                  ),
      ),
    );
  }

  @override
  void dispose() {
    pdfViewerController.dispose();
    super.dispose();
  }
}
