import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MissionMap extends StatelessWidget {
  final LatLng center;

  MissionMap(this.center);
}
