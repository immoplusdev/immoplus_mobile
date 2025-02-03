import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:immoplus/app/modules/photon_location_picker.dart/photon_location_picker_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class PhotonPickerLocationListTile extends StatefulWidget {
  const PhotonPickerLocationListTile({
    super.key,
    required this.placeHolder,
    this.leading,
    required this.onSeleted,
    this.currentValue,
    this.showCurrentPosition = false,
  });
  final String placeHolder;
  final Widget? leading;
  final GeoJSONFeature? currentValue;
  final bool showCurrentPosition;
  final void Function(GeoJSONFeature)? onSeleted;
  @override
  State<PhotonPickerLocationListTile> createState() =>
      _PhotonPickerLocationListTileState();
}

class _PhotonPickerLocationListTileState
    extends State<PhotonPickerLocationListTile> {
  String title = '';
  String subtitle = '';
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        child: ListTile(
          tileColor: CupertinoColors.white,
          horizontalTitleGap: 2,
          title: title.isEmpty
              ? (widget.currentValue == null)
                  ? Text(widget.placeHolder)
                  : Text(widget.currentValue!.properties!['title'].toString())
              : Text(title),
          //contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          subtitle: (subtitle.isNotEmpty)
              ? (widget.currentValue == null)
                  ? Text(subtitle)
                  : Text(
                      widget.currentValue!.properties!['subtitle'].toString())
              : (widget.currentValue != null)
                  ? Text(
                      widget.currentValue!.properties!['subtitle'].toString())
                  : null,
          leading: widget.leading,
          trailing: Icon(
            CupertinoIcons.chevron_right_circle_fill,
            color: AppColors.primary,
          ),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: AppColors.scafold,
              showDragHandle: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              builder: (context) => FractionallySizedBox(
                heightFactor: 0.9,
                child: PhotonLocationPickerPage(
                  showCurrentPosition: widget.showCurrentPosition,
                  onSeleted: (photonModel) {
                    photonModel.geoJson!.properties!['title'] =
                        photonModel.properties!.city;
                    photonModel.geoJson!.properties!['subtitle'] =
                        photonModel.properties!.name;
                    widget.onSeleted!(photonModel.geoJson!);

                    setState(() {
                      title = photonModel.properties!.city ??
                          photonModel.properties!.name!;
                      subtitle = photonModel.properties!.name!;
                    });

                    Navigator.pop(context);
                  },
                  onCurrentPositionSelected: (value) {
                    if (value != null) {
                      widget.onSeleted!(value);
                      setState(() {
                        title = value.properties!['title'];
                        subtitle = subtitle;
                      });

                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
