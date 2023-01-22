import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:jbuti_app/app/components/category_card.dart';
import 'package:jbuti_app/app/modules/category/controllers/category_controller.dart';

class CategoriesView extends GetView {
  const CategoriesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text('Categories',
              style: TextStyle(color: Theme.of(context).hoverColor)),
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Theme.of(context).hoverColor
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: GetBuilder<CategoryController>(
                builder: (cont) {
                  if (cont.isLoadingCategory) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (cont.categories.isEmpty) {
                    return const Center(
                      child: Text("No Category"),
                    );
                  } else {
                    return GridView.builder(
                      itemCount: cont.categories.length,
                      gridDelegate:
                           SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: Get.height/3.4
                      ),
                      itemBuilder: (context, index) => CategoryCard(
                        category: cont.categories[index],
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ));
  }
}
