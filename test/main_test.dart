import 'dart:convert';
import 'dart:io';

void main() {
  final File file = File("assets/data/restaurant.csv");
  Stream<List> inputStream = file.openRead();
  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
    (String line) {
      print(line);
    },
    onDone: () => print("File is closed"),
    onError: (e) => print(e),
  );
}
