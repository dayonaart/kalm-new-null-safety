import 'package:flutter/material.dart';
import 'package:kalm/widget/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

const String kalmWaLink = "https://wa.me/628118777078";
const String kalmInstagram = "https://www.instagram.com/get.kalm/";
const String kalmYoutube =
    'https://www.youtube.com/channel/UC3jglcWjpJE4GtBuY7btnFw';
const String kalmFacebook = "https://www.facebook.com/KALM.id/";
const String kalmWhatsapp = "https://wa.me/628118777078";
const String kalmSite = "https://www.get-kalm.com";
List<String> iconSocialAsset = [
  'assets/icon/whatsapp.png',
  'assets/icon/instagram.png',
  'assets/icon/facebook.png',
  'assets/icon/youtube.png',
];
Row SOCIAL_SHARE() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: List.generate(4, (i) {
      return IconButton(
          onPressed: () async {
            switch (i) {
              case 0:
                try {
                  if (await canLaunch(kalmWaLink)) {
                    await launch(kalmWaLink);
                  } else {
                    ERROR_SNACK_BAR("Perhatian", 'Terjadi kesalahan');
                  }
                } catch (e) {
                  ERROR_SNACK_BAR("Perhatian", '$e');
                }
                break;
              case 1:
                try {
                  if (await canLaunch(kalmInstagram)) {
                    await launch(kalmInstagram);
                  } else {
                    ERROR_SNACK_BAR("Perhatian", 'Terjadi kesalahan');
                  }
                } catch (e) {
                  ERROR_SNACK_BAR("Perhatian", '$e');
                }
                break;
              case 2:
                try {
                  if (await canLaunch(kalmFacebook)) {
                    await launch(kalmFacebook);
                  } else {
                    ERROR_SNACK_BAR("Perhatian", 'Terjadi kesalahan');
                  }
                } catch (e) {
                  ERROR_SNACK_BAR("Perhatian", '$e');
                }
                break;
              case 3:
                try {
                  if (await canLaunch(kalmYoutube)) {
                    await launch(kalmYoutube);
                  } else {
                    ERROR_SNACK_BAR("Perhatian", 'Terjadi kesalahan');
                  }
                } catch (e) {
                  ERROR_SNACK_BAR("Perhatian", '$e');
                }
                break;
              default:
            }
          },
          icon: Image.asset(iconSocialAsset[i]));
    }),
  );
}
