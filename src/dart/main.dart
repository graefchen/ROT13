import 'dart:convert';
import 'dart:io';

const INPUT_TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
const OUTPUT_TABLE = "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm";

String rot13(String s) {
  String str = "";
  for (int i = 0; i < s.length; i++) {
    var ch = s[i];
    for (int t = 0; t < INPUT_TABLE.length; t++) {
      if (ch == INPUT_TABLE[t]) {
        ch = OUTPUT_TABLE[t];
        break;
      }
    }
    str += ch;
  }
  return str;
}

void usage() {
  stderr.write(
      "Usage: rot13: [options] [files]\n options: -h, --help: Print this help message\n");
}

Future<void> main(List<String> args) async {
  int arg_len = args.length;
  for (String arg in args) {
    if (arg == "-h" || arg == "--help") {
      usage();
      exit(1);
    }
  }

  if (arg_len >= 0) {
    if (!stdin.hasTerminal) {
      // The following 11 lines are adapted from the `stdin.readLineSync()` function
      Encoding encoding = systemEncoding;
      final List<int> line = <int>[];
      int byte;
      do {
        byte = stdin.readByteSync();
        if (byte < 0) {
          break;
        }
        line.add(byte);
      } while (byte != 0);
      String s = encoding.decode(line);
      stdout.write(rot13(s));
      exit(0);
    }
  }

  for (String arg in args) {
    if (Directory(arg).existsSync()) {
      stderr.write("rot: $arg: Permission denied");
      exit(1);
    }
    if (!File(arg).existsSync()) {
      stderr.write("rot: couldn't read file: $arg");
      exit(1);
    }
    File file = File(arg);
    String s = file.readAsStringSync();
    stdout.write(rot13(s));
  }

  exit(0);
}
