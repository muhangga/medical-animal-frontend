import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  String? clinicName;
  String? address;
  String? phone;
  String? uLat;
  String? uLong;
  double? cLat;
  double? cLong;
  double? distance;
  DetailPage(
      {Key? key,
      this.clinicName,
      this.address,
      this.phone,
      this.uLat,
      this.uLong,
      this.cLat,
      this.cLong,
      this.distance})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.clinicName!),
      ),
      body: Container(
        child: Column(
          children: [
            Text(widget.address!),
            Text(widget.phone!),
            Text(widget.uLat!),
            Text(widget.uLong!),
            Text(widget.cLat.toString()),
            Text(widget.cLong.toString()),
            Text(widget.distance.toString()),
          ],
        ),
      ),
    );
  }
}
