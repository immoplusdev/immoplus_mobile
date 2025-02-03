import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:immoplus/app/modules/photon_location_picker.dart/photon_model.dart';
import 'package:immoplus/app/services/location_service.dart';
import 'package:immoplus/app/utils/app_colors.dart';

import 'package:shimmer/shimmer.dart';

class PhotonLocationPickerPage extends StatefulWidget {
  const PhotonLocationPickerPage({
    super.key,
    required this.onSeleted,
    required this.onCurrentPositionSelected,
    this.showCurrentPosition = false,
  });
  final bool showCurrentPosition;
  final void Function(PhotonApiResponse photonApiResponse)? onSeleted;

  final void Function(GeoJSONFeature? geoJSONFeature)?
      onCurrentPositionSelected;
  @override
  State<PhotonLocationPickerPage> createState() =>
      _PhotonLocationPickerPageState();
}

class _PhotonLocationPickerPageState extends State<PhotonLocationPickerPage> {
  List<PhotonApiResponse> results = [];
  bool isloading = false;
  getPrediction({required String value}) async {
    setState(() {
      isloading = true;
    });

    try {
      if (value!.isNotEmpty) {
        results.clear();

        Response details = await Dio().get(
          'https://photon.komoot.io/api',
          queryParameters: {
            "q": value,
            "bbox": "-8.5993,4.3571,-2.4930,10.7366",
            "limit": 8,
          },
        );
        inspect(details.data);

        setState(() {
          results = (details.data['features'] as List)
              .map((e) => PhotonApiResponse.fromJson(e))
              .toList();
          inspect(results);
        });
      } else {
        results.clear();
      }
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafold,
      appBar: AppBar(
        backgroundColor: AppColors.scafold,
        toolbarHeight: 5,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            //color: Colors.red,
            child: CupertinoSearchTextField(
              autofocus: true,
              onChanged: (value) {
                EasyDebounce.debounce(value, const Duration(milliseconds: 500),
                    () {
                  getPrediction(value: value);
                });
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Visibility(
          visible: !isloading,
          replacement: Column(
            children: List.generate(
                6,
                (index) => Shimmer.fromColors(
                      period: Duration(milliseconds: 800),
                      baseColor: CupertinoColors.tertiarySystemFill,
                      highlightColor: Colors.grey.shade100,
                      child: ListTile(
                        leading: CircleAvatar(),
                        title: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          width: 200,
                          height: 20,
                        ),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 5, right: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          width: 100,
                          height: 20,
                        ),
                      ),
                    )),
          ),
          child: Column(children: [
            Visibility(
              visible: widget.showCurrentPosition,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10)
                    .copyWith(bottom: 15),
                child: ListTile(
                  tileColor: Colors.white,
                  onTap: () async {
                    isloading = true;
                    final a = await LocationService().getCurrentPosition();
                    isloading = false;
                    inspect(a);
                    widget.onCurrentPositionSelected!(a);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  trailing:
                      const Icon(CupertinoIcons.chevron_right_circle_fill),
                  leading: const Icon(
                    CupertinoIcons.location_fill,
                    color: Colors.blue,
                  ),
                  title: const Text('Prendre ma position actuelle'),
                ),
              ),
            ),
            ...results
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: ListTile(
                      tileColor: Colors.white,
                      onTap: () {
                        inspect(e.geoJson);
                        widget.onSeleted!(e);
                      },
                      leading: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            CupertinoIcons.location_solid,
                            size: 30,
                            color: Colors.blue,
                          )),
                      title: (e.properties!.city == null)
                          ? Text(e.properties!.name ?? 'name')
                          : Text(e.properties!.city ?? 'name'),
                      subtitle: (e.properties!.city != null)
                          ? Text(e.properties!.name ?? 'name')
                          : null,
                    ),
                  ),
                )
                .toList(),
          ]),
        ),
      ),
    );
  }
}
