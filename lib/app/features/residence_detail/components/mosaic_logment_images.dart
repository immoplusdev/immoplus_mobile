import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/features/residence_detail/components/logment_viewer_image.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class MosaicLogmentImages extends StatefulWidget {
  MosaicLogmentImages({super.key, this.imageUrls, required this.tag});
  final Random random = Random();
  final List<String>? imageUrls;
  final String tag;
  @override
  State<MosaicLogmentImages> createState() => _MosaicLogmentImagesState();
}

class _MosaicLogmentImagesState extends State<MosaicLogmentImages> {
  int _previousWidth = 1;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tag,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Icon(
                CupertinoIcons.chevron_back,
                size: 30,
              ),
            ),
            onPressed: () => context.pop(),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: widget.imageUrls!.asMap().entries.map(
              (e) {
                int width = (_previousWidth == 2)
                    ? 2
                    : widget.random.nextBool()
                        ? 2
                        : 4;

                _previousWidth = width;
                return StaggeredGridTile.count(
                  crossAxisCellCount: width,
                  mainAxisCellCount: widget.random.nextInt(3) + 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewerImageLogment(
                                initialPage: e.key,
                                tag: e.value,
                                imageUrls: widget.imageUrls),
                          ));
                    },
                    child: CachedNetworkImage(
                      imageUrl: Utils.getImagePath(
                          id: e
                              .value), //https://pbs.twimg.com/profile_banners/1444928438331224069/1633448972/600x200

                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade400,
                        period: const Duration(milliseconds: 500),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit
                          .cover, // or other BoxFit values as per your design
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
