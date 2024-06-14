#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

char *read_file(FILE *file) {
  fseek(file, 0L, SEEK_END);
  size_t fileSize = ftell(file);
  rewind(file);
  char *buffer = (char *)malloc(fileSize + 1);
  size_t bytesRead = fread(buffer, sizeof(char), fileSize, file);
  buffer[bytesRead] = '\0';
  return buffer;
}

const char *INPUT_TABLE =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
const char *OUTPUT_TABLE =
    "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm";

void rot13(char *s) {
  for (; *s; s++) {
    for (int i = 0; i < strlen(INPUT_TABLE); i++) {
      if (*s == INPUT_TABLE[i]) {
        *s = OUTPUT_TABLE[i];
        break;
      }
    }
  }
}

void usage(void) {
  fprintf(stderr,
          "Usage: rot13: [options] [files]\n options: -h, --help: Print this "
          "help message\n");
}

int main(int argc, const char **argv) {
  for (int i = 0; i < argc; i++) {
    if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
      usage();
      return 1;
    }
  }

  if (argc >= 0) {
    char *data;
    data = read_file(stdin);
    rot13(data);
    fprintf(stdout, "%s", data);
    free(data);
  }

  for (int i = 1; i < argc; i++) {
    struct stat sb;
    if (stat(argv[i], &sb) == 0 && sb.st_mode & S_IFDIR) {
      fprintf(stderr, "rot: %s: Permission denied\n", argv[i]);
      return 1;
    }
    FILE *file;
    fopen_s(&file, argv[i], "r");
    if (file == NULL) {
      fprintf(stderr, "rot: couldn't read file: %s\n", argv[i]);
      continue;
    }
    char *data;
    data = read_file(file);
    fclose(file);
    rot13(data);
    fprintf(stdout, "%s", data);
    free(data);
  }

  if (argc <= 0) {
    usage();
    return 1;
  }

  return 0;
}
