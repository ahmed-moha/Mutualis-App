import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jbuti_app/app/constants.dart';
import 'package:jbuti_app/app/data/category_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category});
final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: Get.height / 4,
      width: Get.width / 3,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: Get.isDarkMode?[]:[
          BoxShadow(
            offset: const Offset(4, 4),
            blurRadius: 10,
            color: kPrimaryColor.withOpacity(.8),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Stack(
          children: <Widget>[
             Positioned(
              top: -20,
              left: -20,
              child: CircleAvatar(
                backgroundColor: kPrimaryColor,
                backgroundImage: ExtendedNetworkImageProvider(category.image??"https://craftsnippets.com/articles_images/placeholder/placeholder.jpg"),
                radius: 60,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children:  <Widget>[
                  Flexible(
                    child: Text(
                    category.label??  "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   Flexible(
                    child: Text(
                     "${category.doctors?.length} Doctors" ,
                       maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                       style: const TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
