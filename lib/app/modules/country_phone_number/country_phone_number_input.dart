part of country_phone_number;

class CountryPhoneNumberInput extends StatefulWidget {
  const CountryPhoneNumberInput({super.key, required this.controller});
  final TextEditingController controller;
  @override
  State<CountryPhoneNumberInput> createState() =>
      _CountryPhoneNumberInputState();
}

class _CountryPhoneNumberInputState extends State<CountryPhoneNumberInput> {
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      fillColor: Colors.white,
      textInputType:
          TextInputType.numberWithOptions(signed: true, decimal: true),
      textInputAction: TextInputAction.done,
      labelText: 'Numéro de téléphone',
      controller: widget.controller,
      sufixIcon: FaIcon(FontAwesomeIcons.whatsapp),
      prefixIcon: CountryCodePicker(
        onChanged: print,
        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
        initialSelection: 'CI',
        favorite: ['+225', 'CI'],
        // optional. Shows only country name and flag
        showFlag: true,
        showFlagMain: true,
        showCountryOnly: true,
        // optional. Shows only country name and flag when popup is closed.
        showOnlyCountryWhenClosed: false,
        // optional. aligns the flag and the Text left
        alignLeft: false,
      ),
      validator: (String? value) =>
          FormUtils.internationalNumberValidator(number: value),
      inputFormatters: [
        MaskTextInputFormatter(
            mask: '## #### ## ##', filter: {'#': RegExp(r'[0-9]')})
      ],
    );
  }
}
