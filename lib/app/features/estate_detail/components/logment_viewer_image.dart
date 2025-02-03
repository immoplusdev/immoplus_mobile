import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewerImageEstate extends StatelessWidget {
  const ViewerImageEstate(
      {super.key,
      required this.tag,
      required this.imageUrls,
      this.initialPage = 0});

  final String tag;
  final int initialPage;
  final List<String>? imageUrls;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: CupertinoColors.systemFill,
              child: IconButton(
                icon: const Icon(
                  CupertinoIcons.chevron_left,
                  color: Colors.white,
                ),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: PhotoViewGallery(
          loadingBuilder: (context, event) => Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          pageController: PageController(
            initialPage: initialPage,
          ),
          pageOptions: imageUrls!
              .map((image) => PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(Utils.getImagePath(id: image)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
