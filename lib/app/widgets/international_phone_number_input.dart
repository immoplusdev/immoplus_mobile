import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class InternationalPhoneInput extends StatefulWidget {
  final Function(String)? onValidPhoneNumber;
  final String initialCountryCode;
  final String? initialPhoneNumber;
  final String? Function(String?)? validator;
  final void Function(bool)? onInputValidated;

  const InternationalPhoneInput({
    super.key,
    this.onValidPhoneNumber,
    this.initialCountryCode = 'CI',
    this.validator,
    this.onInputValidated, // Default to Côte d’Ivoire
    this.initialPhoneNumber,
  });

  @override
  _InternationalPhoneInputState createState() =>
      _InternationalPhoneInputState();
}

class _InternationalPhoneInputState extends State<InternationalPhoneInput> {
  final TextEditingController _controller = TextEditingController();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'CI');
  bool? _isValid;

  @override
  void initState() {
    super.initState();
    _phoneNumber = PhoneNumber(
        isoCode: widget.initialCountryCode,
        phoneNumber: widget.initialPhoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            tileColor: HexColor("#eff5fb"),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                setState(() {
                  _phoneNumber = number;
                });
              },
              onInputValidated: (bool value) {
                setState(() {
                  _isValid = value;
                });
                if (value && widget.onValidPhoneNumber != null) {
                  widget.onValidPhoneNumber!(_phoneNumber.phoneNumber ?? '');
                }
                if (widget.onInputValidated != null) {
                  widget.onInputValidated!(value);
                }
              },
              validator: widget.validator,
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              initialValue: _phoneNumber,
              textFieldController: _controller,
              formatInput: true,
              maxLength: 13,
              spaceBetweenSelectorAndTextField: 0,
              textAlignVertical: TextAlignVertical.center,
              hintText: "Numéro de téléphone",
              keyboardType: TextInputType.phone,
              keyboardAction: TextInputAction.done,
              inputBorder: InputBorder.none,
              selectorConfig: const SelectorConfig(
                leadingPadding: 5,
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                trailingSpace: false,
              ),
              inputDecoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                fillColor: HexColor("#eff5fb"),
                border: InputBorder.none,
                hintText: "Numéro de téléphone",
                errorStyle: const TextStyle(height: 0),
              ),
            ),
          ),
          if (_isValid != null)
            if (!_isValid!)
              Text(
                _isValid!
                    ? 'Le numéro de téléphone est valide.'
                    : 'Le numéro de téléphone est invalide.',
                style: TextStyle(
                  color: _isValid! ? Colors.green : Colors.red,
                  fontSize: 14,
                ),
              ),
        ],
      ),
    );
  }
}
