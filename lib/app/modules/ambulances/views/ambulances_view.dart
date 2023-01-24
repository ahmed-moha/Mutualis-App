import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:jbuti_app/app/data/ambulance_model.dart';
import 'package:jbuti_app/app/modules/ambulances/views/ambulances_enquire_list.dart';
import 'package:jbuti_app/app/modules/ambulances/views/request_ambulance.dart';

import '../../../../generated/locales.g.dart';
import '../controllers/ambulances_controller.dart';

class AmbulancesView extends GetView<AmbulancesController> {
  const AmbulancesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
         LocaleKeys.ambulances.tr,
          style: TextStyle(color: Theme.of(context).hoverColor),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).hoverColor),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyAmbulancesPage(),));
              },
              icon: const Icon(IconlyLight.discovery))
        ],
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/images/ambulance.jpg',
            fit: BoxFit.cover,
            height: 230.0,
            width: double.infinity,
          ),
          Expanded(
            child: GetBuilder<AmbulancesController>(
              builder: (cont) {
                if (cont.isLoadingAmbulance) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (cont.ambulances.isEmpty) {
                  return const Center(
                    child: Text("No Ambulances"),
                  );
                } else {
                  return ListView.builder(
                    itemCount: cont.ambulances.length,
                    itemBuilder: (context, index) =>
                        widgetAmbulance(cont.ambulances[index], context),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetAmbulance(AmbulanceModel ambulance, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: const Offset(4, 4),
            blurRadius: 10,
            color: Colors.grey.withOpacity(.2),
          ),
          BoxShadow(
            offset: const Offset(-3, 0),
            blurRadius: 15,
            color: Colors.grey.withOpacity(.1),
          )
        ],
      ),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestAmbulancePage(
                      ambulance_id: ambulance.id.toString(),
                      ambulance_name: ambulance.nom ?? "",
                      ambulance_phone: ambulance.telephone ?? "",
                      ambulance_adresse: ambulance.adresse ?? "",
                    ),
                  ));
            },
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(13)),
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        //color: AppTheme.randomColor(context),
                      ),
                      child: Image.network(
                        ambulance.photo ?? "",
                        height: 50,
                        width: 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  title: Text(ambulance.nom ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    ambulance.adresse ?? "",
                    //style: TextStyles.bodySm,
                  ),
                  trailing: Text(ambulance.telephone ?? ""),
                ),
              ],
            ),
          )),
    );
  }
}
