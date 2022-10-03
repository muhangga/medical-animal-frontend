import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/api/models/clinic_model.dart';
import 'package:medical_animal/core/common/theme.dart';

class AllClinicItem extends StatefulWidget {
  const AllClinicItem({Key? key}) : super(key: key);

  @override
  State<AllClinicItem> createState() => _AllClinicItemState();
}

class _AllClinicItemState extends State<AllClinicItem> {
  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClinicModel>>(
      future: apiService.getClinic(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<ClinicModel> listClinic = snapshot.data;
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 90),
              child: Column(
                children: listClinic
                    .map((data) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Card(
                            child: Container(
                          padding: const EdgeInsets.all(10),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(6),
                            leading: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            title: Text(
                              data.clinicName!,
                              style: blackTextStyle.copyWith(
                                  fontSize: 18, fontWeight: bold),
                            ),
                            subtitle: Text(data.address!,
                                style: greyTextStyle.copyWith(fontSize: 14)),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.directions,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ))))
                    .toList(),
              ),
            ),
          );
        } else {
          return const SizedBox(
            height: 340,
            child: Center(
              child: SpinKitDoubleBounce(
                color: kSecondaryColor,
              ),
            ),
          );
        }
      },
    );
  }
}
