import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:missionout/common_widgets/mission_map/mission_map.dart';

class GoogleMissionMap extends MissionMap {
  GoogleMissionMap(LatLng center) : super(center);

  @override
  Widget build(BuildContext context) => GoogleMap(
        markers: {
          Marker(
            markerId: MarkerId("Mission Location"),
            position: center,
          )
        },
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
        tiltGesturesEnabled: false,
        zoomGesturesEnabled: false,
        mapType: MapType.terrain,
        initialCameraPosition: CameraPosition(target: center, zoom: 11.0),
      );
}
