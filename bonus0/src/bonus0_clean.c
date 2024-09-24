#include <stdio.h>
#include <string.h>
#include <unistd.h>

void processInput(char *output) {
	char tempInput1[20];
	char tempInput2[20];
	readInput(tempInput1, "Enter first string:");
	readInput(tempInput2, "Enter second string:");
	strcpy(output, tempInput1);
	size_t length = strlen(output);
	output[length] = ' ';
	output[length + 1] = '\0';
	strcat(output, tempInput2);
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
