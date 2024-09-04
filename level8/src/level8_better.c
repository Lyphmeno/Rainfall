#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE 128

char *auth = NULL;
char *service = NULL;

int main(void) {
	char inputBuffer[BUFFER_SIZE];
	char serviceBuffer[125];
	char tempBuffer[2];

	while (1) {
		printf("%p, %p \n", auth, service);
		if (fgets(inputBuffer, BUFFER_SIZE, stdin) == NULL) {
			return 0;
		}
		if (strncmp(inputBuffer, "auth ", 5) == 0) {
			auth = (char *)malloc(4);
			*auth = 0;
			if (strlen(tempBuffer) < 30) {
				strcpy(auth, tempBuffer);
			}
		}
		if (strncmp(inputBuffer, "reset", 5) == 0) {
			free(auth);
		}
		if (strncmp(inputBuffer, "service", 7) == 0) {
			service = strdup(serviceBuffer);
		}
		if (strncmp(inputBuffer, "login", 5) == 0) {
			if (auth && auth[8] == 0) {
				fwrite("Password:\n", 1, 10, stdout);
			} else if (auth) {
				system("/bin/sh");
			}
		}
	}
	return 0;
}