int main(int argc, char *argv[]) {
	int result;
	int index;
	int buffer[16] = {0};
	char readBuffer[66] = {0};
	FILE *file;

	file = fopen("/home/user/end/.pass", "r");
	if (file == NULL || argc != 2) {
		result = -1;
	} else {
		fread(buffer, 1, 66, file);
		index = atoi(argv[1]);
		((char *)buffer)[index] = '\0';
		fread(readBuffer, 1, 65, file);
		fclose(file);
		if (strcmp((char *)buffer, argv[1]) == 0) {
			execl("/bin/sh", "sh", NULL);
		} else {
			puts(readBuffer);
		}
		result = 0;
	}
	return result;
}