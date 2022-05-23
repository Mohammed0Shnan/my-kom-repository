import 'package:my_kom/module_orders/response/branch.dart';

class OrderDetailsResponse {
 late int id;
 late String orderID;
 late String captainID;
 late Date date;
 late Null duration;
 late List<String> source;
 late List<String> destination;
 late Date orderDate;
 late Date orderUpdateDate;
 late String orderNote;
 late String payment;
 late String state;
 late List<Record> record;

  OrderDetailsResponse(
      {
       required this.id,
       required this.orderID,
       required this.captainID,
       required this.date,
       required this.duration,
       required this.source,
       required this.destination,
      required  this.orderDate,
       required this.orderUpdateDate,
       required this.orderNote,
       required this.payment,
       required this.state,
      required  this.record});

  OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderID = json['orderID'];
    captainID = json['captainID'];
    date = (json['date'] != null ? new Date.fromJson(json['date']) : null)!;
    duration = json['duration'];
    // source = json['source'].cast<String>();
    // destination = json['destination'].cast<String>();
    orderDate =
    (json['orderDate'] != null ? new Date.fromJson(json['orderDate']) : null)!;
    orderUpdateDate = json['orderUpdateDate'];
    orderNote = json['orderNote'];
    payment = json['payment'];
    state = json['state'];
    if (json['record'] != null) {
      record = <Record>[];
      json['record'].forEach((v) {
        record.add(new Record.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['orderID'] = this.orderID;
    data['captainID'] = this.captainID;
    if (this.date != null) {
      data['date'] = this.date.toJson();
    }
    data['duration'] = this.duration;
    data['source'] = this.source;
    data['destination'] = this.destination;
    if (this.orderDate != null) {
      data['orderDate'] = this.orderDate.toJson();
    }
    data['orderUpdateDate'] = this.orderUpdateDate;
    data['orderNote'] = this.orderNote;
    data['payment'] = this.payment;
    data['state'] = this.state;
    if (this.record != null) {
      data['record'] = this.record.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Date {
 late Timezone timezone;
 late int offset;
 late int timestamp;

  Date({required this.timezone,required this.offset,required this.timestamp});

  Date.fromJson(Map<String, dynamic> json) {
    timezone = (json['timezone'] != null
        ? new Timezone.fromJson(json['timezone'])
        : null)!;
    offset = json['offset'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.timezone != null) {
      data['timezone'] = this.timezone.toJson();
    }
    data['offset'] = this.offset;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Timezone {
 late String name;
 late List<Transitions> transitions;
 late Location location;

  Timezone({required this.name,required this.transitions,required this.location});

  Timezone.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['transitions'] != null) {
      transitions = <Transitions>[];
      json['transitions'].forEach((v) {
        transitions.add(new Transitions.fromJson(v));
      });
    }
    location = (json['location'] != null
        ? new Location.fromJson(json['location'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = this.name;
    if (this.transitions != null) {
      data['transitions'] = this.transitions.map((v) => v.toJson()).toList();
    }
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    return data;
  }
}

class Transitions {
 late int ts;
 late String time;
 late int offset;
 late bool isdst;
 late String abbr;

  Transitions({required this.ts,required this.time,required this.offset,required this.isdst,required this.abbr});

  Transitions.fromJson(Map<String, dynamic> json) {
    ts = json['ts'];
    time = json['time'];
    offset = json['offset'];
    isdst = json['isdst'];
    abbr = json['abbr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ts'] = this.ts;
    data['time'] = this.time;
    data['offset'] = this.offset;
    data['isdst'] = this.isdst;
    data['abbr'] = this.abbr;
    return data;
  }
}

class Location {
late  String countryCode;
 late int latitude;
 late int longitude;
 late String comments;

  Location({required this.countryCode,required this.latitude,required this.longitude,required this.comments});

  Location.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_code'] = this.countryCode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['comments'] = this.comments;
    return data;
  }
}

class Record {
 late int id;
late  String orderID;
late  String state;
 late Date startTime;

  Record({required this.id,required this.orderID,required this.state,required this.startTime});

  Record.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderID = json['orderID'];
    state = json['state'];
    startTime =
    (json['startTime'] != null ? new Date.fromJson(json['startTime']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['orderID'] = this.orderID;
    data['state'] = this.state;
    if (this.startTime != null) {
      data['startTime'] = this.startTime.toJson();
    }
    return data;
  }
}

class CreateBranchResponse {
 late var statusCode;
 late String msg;
 late Branch data;

  CreateBranchResponse({this.statusCode,required this.msg,required this.data});

  CreateBranchResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    msg = json['msg'];
    data = (json['Data'] != null ? new Branch.fromJson(json['Data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_code'] = this.statusCode;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}



