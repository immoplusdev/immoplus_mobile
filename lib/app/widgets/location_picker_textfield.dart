// part of sharedWidgets;

// class LocationPickerTextField extends StatelessWidget {
//   const LocationPickerTextField({
//     super.key,
//     required this.textEditingController,
//     this.hintText,
//     this.label,
//     this.prefixIcon,
//   });
//   final TextEditingController textEditingController;
//   final String? hintText;
//   final String? label;
//   final Widget? prefixIcon;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 0),
//       child: GooglePlaceAutoCompleteTextField(
//         textEditingController: textEditingController,
//         googleAPIKey: Constantes.mapToken,
//         boxDecoration: BoxDecoration(
//             color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
//         inputDecoration: InputDecoration(
//           contentPadding: EdgeInsets.zero,
//           prefixIcon: prefixIcon,
//           hintText: hintText,
//           label: label != null ? Text(label ?? '') : null,
//           filled: true,
//           fillColor: CupertinoColors.systemFill,
//         ),
//         //debounceTime: 800, // default 600 ms,
//         countries: [
//           "ci",
//           //"fr"
//         ], // optional by default null is set

//         isLatLngRequired: true, // if you required coordinates from place detail
//         getPlaceDetailWithLatLng: (Prediction
//             prediction) {}, // this callback is called when isLatLngRequired is true

//         itemClick: (Prediction prediction) {
//           textEditingController.text = prediction.description!;
//           textEditingController.selection = TextSelection.fromPosition(
//               TextPosition(offset: prediction.description!.length));

//           //_formController.placeLoading!.clear();
//         },
//       ),
//     );
//   }
// }
