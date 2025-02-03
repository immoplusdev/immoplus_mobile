part of country_phone_number;

class CountryPhonrNumberPopup extends StatefulWidget {
  const CountryPhonrNumberPopup({super.key});

  @override
  State<CountryPhonrNumberPopup> createState() =>
      _CountryPhonrNumberPopupState();
}

class _CountryPhonrNumberPopupState extends State<CountryPhonrNumberPopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CountryCodePicker(
        onChanged: print,
        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
        initialSelection: 'FR',
        favorite: ['+39', 'FR'],
        // optional. Shows only country name and flag
        showCountryOnly: false,
        // optional. Shows only country name and flag when popup is closed.
        showOnlyCountryWhenClosed: false,
        // optional. aligns the flag and the Text left
        alignLeft: false,
      ),
    );
  }
}
