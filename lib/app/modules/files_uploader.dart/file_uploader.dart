import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immoplus/app/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';

import 'package:shimmer/shimmer.dart';

class FileUploader extends StatefulWidget {
  const FileUploader({
    super.key,
    required this.fileUploaderController,
    this.title,
    this.width,
    this.height,
    this.iconPlaceholder,
    this.placeholderImageId,
  });
  final FileUploaderController fileUploaderController;
  final String? title;
  final double? width;
  final double? height;
  final IconData? iconPlaceholder;
  final String? placeholderImageId;
  @override
  State<FileUploader> createState() => _FileUploaderState();
}

class _FileUploaderState extends State<FileUploader> {
  bool loading = false;
  Future<XFile?> _getImage() => showModalBottomSheet<XFile?>(
        context: context,
        useSafeArea: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.scafold,
        showDragHandle: true,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              tileColor: Colors.white,
              onTap: () {
                ImagePicker()
                    .pickImage(source: ImageSource.camera, imageQuality: 40)
                    .then(
                  (value) {
                    Navigator.pop(context, value);
                  },
                );
              },
              leading: const FaIcon(FontAwesomeIcons.camera),
              title: const Text("À partir de la caméra"),
            ),
            const Divider(),
            ListTile(
              tileColor: Colors.white,
              onTap: () {
                ImagePicker()
                    .pickImage(source: ImageSource.gallery, imageQuality: 40)
                    .then(
                  (value) {
                    Navigator.pop(context, value);
                  },
                );
              },
              leading: const FaIcon(FontAwesomeIcons.folder),
              title: const Text("À partir de la gallérie"),
            ),
            const Gap(30),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                spreadRadius: 3, blurRadius: 8, color: Colors.grey.shade300)
          ]),
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              setState(() {
                loading = true;
              });
              try {
                XFile? file = await _getImage();

                setState(() {
                  loading = false;
                  if (file != null) {
                    widget.fileUploaderController.filePath = file.path;
                    widget.fileUploaderController.file = File(file.path);
                  }
                });
              } catch (e) {
                setState(() {
                  loading = false;
                });
              }
            },
            child: DottedBorder(
              radius: const Radius.circular(15),
              borderType: BorderType.RRect,
              child: loading
                  ? Shimmer.fromColors(
                      period: const Duration(milliseconds: 800),
                      baseColor: CupertinoColors.tertiarySystemFill,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: widget.width ?? 180,
                        height: widget.height ?? 180,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    )
                  : Container(
                      width: widget.width ?? 180,
                      height: widget.height ?? 180,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15),
                        image: (widget.fileUploaderController.filePath == null)
                            ? null
                            : DecorationImage(
                                image: FileImage(File(widget
                                    .fileUploaderController.filePath
                                    .toString())),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: (widget.placeholderImageId != null &&
                              widget.fileUploaderController.filePath == null)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: Utils.getImagePath(
                                    id: widget.placeholderImageId!),

                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
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
                            )
                          : (widget.fileUploaderController.filePath == null)
                              ? Center(
                                  child: Icon(
                                    widget.iconPlaceholder ??
                                        FontAwesomeIcons.camera.data,
                                    size: 50,
                                    color: Colors.grey.shade500,
                                  ),
                                )
                              : null,
                    ),
            ),
          ),
          const Gap(5),
          Text(
            widget.title ?? 'Selectionner une image',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: AppColors.primary),
          )
        ],
      ),
    );
  }
}
