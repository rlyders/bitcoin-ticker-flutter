import 'package:intl/intl.dart';

String getBottleStr(int bottleCount) {
  String pluralS = bottleCount != 1 ? 's' : '';
  return '${bottleCount > 0 ? bottleCount : 'no more'} bottle$pluralS of beer';
}

void main() {
  for (var bottleCount = 99; bottleCount >= 0; bottleCount--) {
    print(toBeginningOfSentenceCase(
        '${getBottleStr(bottleCount)} on the wall, ${getBottleStr(bottleCount)}.'));
    if (bottleCount > 0) {
      print(
          'Take on down and pass it around, ${getBottleStr(bottleCount - 1)} on the wall.\n');
    } else {
      print(toBeginningOfSentenceCase(
          'Go to the store and buy some more, 99 bottles of beer on the wall.\n'));
    }
  }
}
