class Mission {
  final String key;
  final String description;
  final DateTime time;
  final String location;
  final String needForAction;
  final String locationDescription;
  final bool isStoodDown;

  Mission(description, needForAction, locationDescription)
      : this.key = null,
        this.description = description,
        this.time = null,
        this.location = null,
        this.needForAction = needForAction,
        this.locationDescription = locationDescription,
        this.isStoodDown = false;

  Mission.fromJson(Map json)
      : key = json['key'],
        description = json['description'],
        time = json['time'],
        location = json['location'],
        needForAction = json['needForAction'],
        locationDescription = json['locationDescription'],
        isStoodDown = json['isStoodDown'];
}
