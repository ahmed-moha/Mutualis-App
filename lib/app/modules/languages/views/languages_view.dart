import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../controllers/languages_controller.dart';

class LanguagesView extends GetView<LanguagesController> {
  const LanguagesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).cardColor,
          iconTheme: IconThemeData(color: Theme.of(context).hoverColor),
          title: Text(
            LocaleKeys.languages.tr,
            style: TextStyle(color: Theme.of(context).hoverColor),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Obx(
              () => LanguageChoiceTile(
                language: LanguageModel(
                  icon: 'assets/icons/so.svg',
                  title: LocaleKeys.somali.tr,
                  locale: const Locale('so', 'SO'),
                ),
                selected: controller.selectedLanguage.value == Languages.somali,
                onPressed: () => controller.changeLanguage(Languages.somali),
              ),
            ),
            Obx(
              () => LanguageChoiceTile(
                language: LanguageModel(
                  icon: 'assets/icons/gb.svg',
                  title: LocaleKeys.english.tr,
                  locale: const Locale('en', 'US'),
                ),
                selected:
                    controller.selectedLanguage.value == Languages.english,
                onPressed: () => controller.changeLanguage(Languages.english),
              ),
            ),
            Obx(
              () => LanguageChoiceTile(
                language: LanguageModel(
                  icon: 'assets/icons/fr.svg',
                  title: LocaleKeys.french.tr,
                  locale: const Locale('fr', 'FR'),
                ),
                selected: controller.selectedLanguage.value == Languages.arabic,
                onPressed: () => controller.changeLanguage(Languages.arabic),
              ),
            ),
          ],
        ),
      );
  }
}



class LanguageModel {
  LanguageModel({
    required this.icon,
    required this.title,
    required this.locale,
  });
  Locale locale;
  String icon, title;
}

class LanguageChoiceTile extends StatelessWidget {
  const LanguageChoiceTile({
    Key? key,
    required this.language,
    this.onPressed,
    this.selected = false,
  }) : super(key: key);

  final LanguageModel language;
  final void Function()? onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          // border: Border.all(
          //     width: selected ? 2 : 0.5,
          //     color: selected
          //         ? Get.theme.primaryColor
          //         : Get.theme.hoverColor.withOpacity(0.17)),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: selected? Get.isDarkMode?[]: [
            BoxShadow(
              blurRadius: 12.0,
              color: Colors.grey.shade100,
              offset: const Offset(1,10)
            ),
             BoxShadow(
              blurRadius: 12.0,
              color: Colors.grey.shade100,
              offset: const Offset(1,10)
            ),
          ]:[]
        ),
        height: 65,
        child: TextButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          )),
          onPressed: onPressed,
          child: Row(
            children: [
              SvgPicture.asset(language.icon, width: 30),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  language.title,
                  style: TextStyle(
                    color:
                        Get.isDarkMode ? Colors.white : Get.theme.primaryColor,
                  ),
                ),
              ),
              selected
                  ? Icon(
                      CupertinoIcons.check_mark_circled_solid,
                      color: Get.isDarkMode
                          ? Get.theme.colorScheme.secondary
                          : Get.theme.primaryColor,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
