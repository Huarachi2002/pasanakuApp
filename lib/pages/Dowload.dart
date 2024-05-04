import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class SingleDownloader extends StatefulWidget {
  static const name = 'downlader-screen';
  const SingleDownloader({super.key});

  @override
  State<SingleDownloader> createState() => _SingleDownloaderState();
}

class _SingleDownloaderState extends State<SingleDownloader> {
  TextEditingController url = TextEditingController();
  double? _progress;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Download Any File From URL\nin Flutter',
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: url,
              decoration: const InputDecoration(label: Text('Url*')),
            ),
            const SizedBox(height: 16),
            _progress != null
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      FileDownloader.downloadFile(
                          url: url.text.trim(),
                          onProgress: (name, progress) {
                            setState(() {
                              _progress = progress;
                            });
                          },
                          onDownloadCompleted: (value) {
                            print('path  $value ');
                            setState(() {
                              _progress = null;
                            });
                          },
                          onDownloadError: (errorMessage) {
                            print('DOWNLOAD ERROR: $errorMessage');
                          },
                          notificationType: NotificationType.all,
                          onDownloadRequestIdReceived: (downloadId) {
                            print('downloadId: $downloadId');
                          },
                      );
                    },
                    child: const Text('Download')),
          ],
        ),
      ),
    );

  }
}