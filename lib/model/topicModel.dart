
class Message {
  Header header;
  List<Status> status;
  bool isTopicAvailable;

  Message({required this.header, required this.status,required this.isTopicAvailable});

  factory Message.fromJson(Map<String, dynamic> json,bool topicStatus) {
    return Message(
      header: Header.fromJson(json['header']),
      status: (json['status'] as List)
          .map((statusJson) => Status.fromJson(statusJson))
          .toList(),
      isTopicAvailable:topicStatus
    );
  }
}

class Header {
  int seq;
  Stamp stamp;
  String frameId;

  Header({required this.seq, required this.stamp, required this.frameId});

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      seq: json['seq'],
      stamp: Stamp.fromJson(json['stamp']),
      frameId: json['frame_id'],
    );
  }
}

class Stamp {
  int secs;
  int nsecs;

  Stamp({required this.secs, required this.nsecs});

  factory Stamp.fromJson(Map<String, dynamic> json) {
    return Stamp(
      secs: json['secs'],
      nsecs: json['nsecs'],
    );
  }
}

class Status {
  int level;
  String name;
  String message;
  String hardwareId;
  List<Value> values;

  Status({
    required this.level,
    required this.name,
    required this.message,
    required this.hardwareId,
    required this.values,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      level: json['level'],
      name: json['name'],
      message: json['message'],
      hardwareId: json['hardware_id'],
      values: (json['values'] as List)
          .map((valueJson) => Value.fromJson(valueJson))
          .toList(),
    );
  }
}

class Value {
  String key;
  String value;

  Value({required this.key, required this.value});

  factory Value.fromJson(Map<String, dynamic> json) {
    return Value(
      key: json['key'],
      value: json['value'],
    );
  }
}
