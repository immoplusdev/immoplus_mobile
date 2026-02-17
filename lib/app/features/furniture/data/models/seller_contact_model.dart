class SellerContactModel {
  final String? sellerName;
  final String? whatsappPhone;
  final String? callPhone;

  const SellerContactModel({
    this.sellerName,
    this.whatsappPhone,
    this.callPhone,
  });

  factory SellerContactModel.fromJson(Map<String, dynamic> json) {
    return SellerContactModel(
      sellerName: json['sellerName'] as String?,
      whatsappPhone: json['whatsappPhone'] as String?,
      callPhone: json['callPhone'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'sellerName': sellerName,
        'whatsappPhone': whatsappPhone,
        'callPhone': callPhone,
      };

  bool get hasWhatsApp => whatsappPhone != null && whatsappPhone!.isNotEmpty;
  bool get hasCallPhone => callPhone != null && callPhone!.isNotEmpty;
}
