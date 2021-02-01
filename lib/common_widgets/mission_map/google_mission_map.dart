import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logging/logging.dart';
import 'package:missionout/common_widgets/mission_map/mission_map.dart';
import 'package:missionout/core/location.dart' as my_implementation;

class GoogleMissionMap extends MissionMap {
  final _log = Logger("google_mission_map.dart");

  final LatLng googleCenter;

  GoogleMissionMap(my_implementation.LatLng center)
      : googleCenter = LatLng(center.latitude, center.longitude),
        super(center);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: {
        Marker(
          markerId: MarkerId("Mission Location"),
          position: googleCenter,
        )
      },
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: false,
      tiltGesturesEnabled: false,
      zoomGesturesEnabled: false,
      mapType: MapType.terrain,
      initialCameraPosition: CameraPosition(target: googleCenter, zoom: 11.0),
    );
  }
}
