//class MyLinkData {
//  String startLabel;
//  String endLabel;
//
//  MyLinkData({
//    this.startLabel = '',
//    this.endLabel = '',
//  });
//
//  MyLinkData.copy(MyLinkData customData)
//      : this(
//          startLabel: customData.startLabel,
//          endLabel: customData.endLabel,
//        );
//}


class MyLinkData {
  String startLabel;
  String endLabel;

  MyLinkData({
    this.startLabel = '',
    this.endLabel = '',
  });

  MyLinkData.copy(MyLinkData customData)
      : this(
    startLabel: customData.startLabel,
    endLabel: customData.endLabel,
  );

  // Add the fromJson factory method
  factory MyLinkData.fromJson(Map<String, dynamic> json) {
    return MyLinkData(
      startLabel: json['startLabel'] ?? '',
      endLabel: json['endLabel'] ?? '',
    );
  }
}
