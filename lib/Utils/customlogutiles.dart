class Customlogutils {
  static const bool printLog = true; 
}

class CustomLog {
  static log(String message, {bool? printLog=true}) {
    if (printLog ?? Customlogutils.printLog) {
      print(message);
    }
  }
}