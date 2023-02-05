import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:psinsx/models/dmsx_model.dart';

class ShowMapFromSearch extends StatefulWidget {
  final Dmsxmodel dmsxmodel;

  const ShowMapFromSearch({
    Key key,
    @required this.dmsxmodel,
  }) : super(key: key);

  @override
  State<ShowMapFromSearch> createState() => _ShowMapFromSearchState();
}

class _ShowMapFromSearchState extends State<ShowMapFromSearch> {
  Dmsxmodel dmsxmodel;

  @override
  void initState() {
    super.initState();
    dmsxmodel = widget.dmsxmodel;
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('id'),
        position: LatLng(
          double.parse(dmsxmodel.lat.trim()),
          double.parse(
            dmsxmodel.lng.trim(),
          ),
        ),
        infoWindow:
            InfoWindow(title: dmsxmodel.cusName, snippet: dmsxmodel.address),
      ),
    ].toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dmsxmodel.ca),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.parse(dmsxmodel.lat.trim()),
                  double.parse(
                    dmsxmodel.lng.trim(),
                  ),
                ),
                zoom: 16),
            markers: myMarker(),
            myLocationEnabled: true,
          ),
        ),
      ),
    );
  }
}
