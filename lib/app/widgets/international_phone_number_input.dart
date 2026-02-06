import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class InternationalPhoneInput extends StatefulWidget {
  final Function(String)? onValidPhoneNumber;
  final String initialCountryCode;
  final String? initialPhoneNumber;
  final String? Function(String?)? validator;
  final void Function(bool)? onInputValidated;
  final Color? backgroundColor;
  final bool isEnabled;

  const InternationalPhoneInput({
    super.key,
    this.onValidPhoneNumber,
    this.initialCountryCode = 'CI',
    this.validator,
    this.onInputValidated,
    this.initialPhoneNumber,
    this.backgroundColor,
    this.isEnabled = true,
  });

  @override
  _InternationalPhoneInputState createState() =>
      _InternationalPhoneInputState();
}

class _InternationalPhoneInputState extends State<InternationalPhoneInput> {
  final TextEditingController _controller = TextEditingController();
  late PhoneNumber _phoneNumber;
  late PhoneNumber
      _initialPhoneNumber; // AJOUT : Variable statique pour initialValue
  final ValueNotifier<bool?> _isValidNotifier = ValueNotifier<bool?>(null);

  @override
  void initState() {
    super.initState();
    // MODIFICATION : Créer une valeur initiale séparée qui ne change jamais
    _initialPhoneNumber = PhoneNumber(
      isoCode: widget.initialCountryCode,
      phoneNumber: widget.initialPhoneNumber,
    );
    _phoneNumber = _initialPhoneNumber; // Initialiser la valeur courante
  }

  @override
  void dispose() {
    _isValidNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InternationalPhoneNumberInput(
        isEnabled: widget.isEnabled,
        onInputChanged: (PhoneNumber number) {
          _phoneNumber = number;
        },
        onInputValidated: (bool value) {
          if (_isValidNotifier.value != value) {
            _isValidNotifier.value = value;
          }
          if (value && widget.onValidPhoneNumber != null) {
            widget.onValidPhoneNumber!(_phoneNumber.phoneNumber ?? '');
          }
          if (widget.onInputValidated != null) {
            widget.onInputValidated!(value);
          }
        },
        // validator: widget.validator,
        validator: null,
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        initialValue:
            _initialPhoneNumber, // MODIFICATION : Utiliser la valeur statique
        textFieldController: _controller,
        formatInput: true,
        maxLength: 13,
        spaceBetweenSelectorAndTextField: 0,
        textAlignVertical: TextAlignVertical.center,
        errorMessage: "Le numéro de téléphone est incorrect",
        searchBoxDecoration: InputDecoration(
          labelText: "Rechercher un pays",
        ),
        hintText: "Numéro de téléphone",
        keyboardType: TextInputType.phone,
        keyboardAction: TextInputAction.done,
        inputBorder: InputBorder.none,
        selectorConfig: const SelectorConfig(
          leadingPadding: 16,
          setSelectorButtonAsPrefixIcon: true,
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          trailingSpace: false,
        ),
        selectorTextStyle: Theme.of(context).textTheme.bodyLarge,
        inputDecoration: InputDecoration(
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          suffixIcon: const Icon(
            FontAwesomeIcons.whatsapp,
            size: 20,
            color: Colors.green,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusButton),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusButton),
            borderSide: BorderSide.none,
          ),
          fillColor: AppColors.ECECEC,
          errorStyle: const TextStyle(color: Colors.redAccent),
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          hintText: "Numéro de téléphone",
        ),
      ),
    );
  }
}
