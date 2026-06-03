class VerifyOtpExtra {
  final String? email;
  final String? phoneNumber;
  final bool? isWhatsapp;
  final void Function()? onSuccess;

  VerifyOtpExtra({
    this.email,
    this.phoneNumber,
    this.isWhatsapp,
    this.onSuccess,
  });
}
