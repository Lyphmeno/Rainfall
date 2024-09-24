void greet_user(void)
{
	char greeting[];

	if (language == 1) {
		strcpy(greeting, "Hyvää päivää");
	}
	else if (language == 2) {
		strcpy(greeting, "Goedemiddag!");
	}
	else if (language == 0) {
		strcpy(greeting, "Hello!");
	}
	puts(greeting);
	return ;
}

int main(int argc, char *argv[])
{
	char name[40];
	char message[32];
	char *lang_env;

	if (argc == 3) {
		memset(name, 0, sizeof(name));
		memset(message, 0, sizeof(message));
		strncpy(name, argv[1], sizeof(name) - 1);
		strncpy(message, argv[2], sizeof(message) - 1);
		lang_env = getenv("LANG");
		if (lang_env != NULL) {
			if (memcmp(lang_env, "fi", 2) == 0) {
				language = 1;
			} else if (memcmp(lang_env, "nl", 2) == 0) {
				language = 2;
			}
		}
		greet_user();
		return 0;
	}
	else {
		return 1;
	}
}