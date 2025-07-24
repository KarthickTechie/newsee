class Customlogutils {
  static const bool printLog = true;
}

class CustomLog {
  static void print(String message, {bool? printLog = true}) {
    if (printLog ?? Customlogutils.printLog) {
      print(message);
    }
  }
}
