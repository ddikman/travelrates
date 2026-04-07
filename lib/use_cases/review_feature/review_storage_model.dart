import 'dart:convert';

class ReviewStorageModel {
  int conversionsDone = 0;
  int conversionsRequired = 5;
  bool submitted = false;

  ReviewStorageModel(
      {required this.conversionsDone,
      required this.conversionsRequired,
      required this.submitted});

  factory ReviewStorageModel.fromJson(String json) {
    var map = JsonDecoder().convert(json);
    return ReviewStorageModel(
        conversionsRequired: map['conversionRequired'],
        conversionsDone: map['conversionDone'],
        submitted: map['submitted']);
  }

  String toJson() => JsonEncoder().convert({
        'conversionRequired': conversionsRequired,
        'conversionDone': conversionsDone,
        'submitted': submitted
      });
}
