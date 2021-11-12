import 'dart:math';
import 'dart:ui';

class Utils {
  static final random = new Random.secure();

  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static List<int> shuffleSecure(List<int> items) {
    for (var i = items.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }
    return items;
  }

  static int getTime() {
    return (DateTime
        .now()
        .millisecondsSinceEpoch / 1000).round();
  }

  static int getTimeMs() {
    return DateTime
        .now()
        .millisecondsSinceEpoch;
  }

  static List<String> splitStringByChunk(String str, int chunkSize) {
    List<String> data = [];
    for (int i = 0; i < str.length; i+= chunkSize) {
      int maxSize = i + chunkSize;
      if (maxSize >= str.length) {
        maxSize = str.length;
      }
      data.add(str.substring(i, maxSize));
    }
    return data;
  }
}