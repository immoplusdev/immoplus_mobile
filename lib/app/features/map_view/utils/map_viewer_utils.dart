enum MapSubjectState {
  reservation,
  visit,
  land,
}

class MapViewerUtils {
  // static Future<Uint8List> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
  //       targetWidth: width);
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
  //       .buffer
  //       .asUint8List();
  // }

  // static ValueNotifier<MapSubjectState> subjectMapNotifier =
  //     ValueNotifier<MapSubjectState>(MapSubjectState.reservation);

  // static lisTenState({required BuildContext context}) {
  //   subjectMapNotifier.addListener(() {
  //     if (subjectMapNotifier.value == MapSubjectState.reservation) {
  //       context.read<MapViewerCubit>().onGetLogments(context: context);
  //     } else if (subjectMapNotifier.value == MapSubjectState.visit) {
  //       context.read<MapViewerCubit>().onGetData(context: context, category: 2);
  //     } else if (subjectMapNotifier.value == MapSubjectState.land) {
  //       context.read<MapViewerCubit>().onGetData(context: context, category: 4);
  //     }
  //   });
  // }
//chemin entre deux points
  // static void _getPathBetweenPoints() async {
  //   PolylineResult points = await MapUtils.getPathBetWeenPoints(
  //           origin: LatLng(LocationService.currentPosition!.latitude,
  //               LocationService.currentPosition!.longitude),
  //           dest: LatLng(5.33352525761603, -3.9780787378549576))
  //       .then(
  //     (value) {
  //       int num = 0;

  //       List<LatLng> _points = [];
  //       value.points.forEach((e) {
  //         num++;

  //         _points.add(LatLng(e.latitude, e.longitude));
  //       });
  //       Polyline _path = Polyline(
  //         onTap: () {},
  //         polylineId: PolylineId('polyline'),
  //         color: Colors.blue.shade800,
  //         width: 3,
  //         points: _points,
  //       );

  //       // _polylines.add(_path);

  //       return value;
  //     },
  //   );
  // }
}
