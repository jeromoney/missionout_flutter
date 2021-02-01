import 'package:flutter/material.dart';
import 'package:missionout/core/location.dart';

abstract class MissionMap extends StatelessWidget {
  final LatLng center;
  const MissionMap(this.center);
}
