#include <stdio.h>
#include <string.h>
#include <unistd.h>

void processInput(char *result) {
	char tempInput1[20];
	char tempInput2[20];
	readInput(tempInput1, "Enter first string:");
	readInput(tempInput2, "Enter second string:");
	strcpy(result, tempInput1);
	size_t length = strlen(result);
	result[length] = ' ';
	result[length + 1] = '\0';
	strcat(result, tempInput2);
}

void readInput(char *buffer, char *prompt) {
	char userInput[4104];
	puts(prompt);
	read(0, userInput, 4096);
	char *newlinePos = strchr(userInput, '\n');
	*newlinePos = '\0';
	strncpy(buffer, userInput, 20);
}

int main(void) {
	char result[54];
	processInput(result);
	puts(result);
	return 0;
}
