class FirebaseWordingModel {
  String? uniqcodeRequired;
  String? cantOpenInstagram;
  String? pleaseWait;
  String? sessionExpired;
  String? waitingProcess;
  String? copied;
  String? cantOpenFacebook;
  String? cantOpenWhatsapp;
  String? errorSaveStorage;
  String? somethingWentWrong;
  String? cantCall119;
  String? addressValidation;
  String? ageValidation;
  String? cantOpenLink;
  String? shareFromKalm;
  String? cantOpenYoutube;
  String? questionerDataValidation;
  String? youHaveMoreTry;
  String? cantOpenShopee;

  FirebaseWordingModel({
    this.uniqcodeRequired,
    this.cantOpenInstagram,
    this.pleaseWait,
    this.sessionExpired,
    this.waitingProcess,
    this.copied,
    this.cantOpenFacebook,
    this.cantOpenWhatsapp,
    this.errorSaveStorage,
    this.somethingWentWrong,
    this.cantCall119,
    this.addressValidation,
    this.ageValidation,
    this.cantOpenLink,
    this.shareFromKalm,
    this.cantOpenYoutube,
    this.questionerDataValidation,
    this.youHaveMoreTry,
    this.cantOpenShopee,
  });

  factory FirebaseWordingModel.fromJson(Map<String, dynamic> json) {
    return FirebaseWordingModel(
      uniqcodeRequired: json['uniqcode_required'] as String?,
      cantOpenInstagram: json['cant_open_instagram'] as String?,
      pleaseWait: json['please_wait'] as String?,
      sessionExpired: json['session_expired'] as String?,
      waitingProcess: json['waiting_process'] as String?,
      copied: json['copied'] as String?,
      cantOpenFacebook: json['cant_open_facebook'] as String?,
      cantOpenWhatsapp: json['cant_open_whatsapp'] as String?,
      errorSaveStorage: json['error_save_storage'] as String?,
      somethingWentWrong: json['something_went_wrong'] as String?,
      cantCall119: json['cant_call_119'] as String?,
      addressValidation: json['address_validation'] as String?,
      ageValidation: json['age_validation'] as String?,
      cantOpenLink: json['cant_open_link'] as String?,
      shareFromKalm: json['share_from_kalm'] as String?,
      cantOpenYoutube: json['cant_open_youtube'] as String?,
      questionerDataValidation: json['questioner_data_validation'] as String?,
      youHaveMoreTry: json['you_have_more_try'] as String?,
      cantOpenShopee: json['cant_open_shopee'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'uniqcode_required': uniqcodeRequired,
        'cant_open_instagram': cantOpenInstagram,
        'please_wait': pleaseWait,
        'session_expired': sessionExpired,
        'waiting_process': waitingProcess,
        'copied': copied,
        'cant_open_facebook': cantOpenFacebook,
        'cant_open_whatsapp': cantOpenWhatsapp,
        'error_save_storage': errorSaveStorage,
        'something_went_wrong': somethingWentWrong,
        'cant_call_119': cantCall119,
        'address_validation': addressValidation,
        'age_validation': ageValidation,
        'cant_open_link': cantOpenLink,
        'share_from_kalm': shareFromKalm,
        'cant_open_youtube': cantOpenYoutube,
        'questioner_data_validation': questionerDataValidation,
        'you_have_more_try': youHaveMoreTry,
        'cant_open_shopee': cantOpenShopee,
      };
}
