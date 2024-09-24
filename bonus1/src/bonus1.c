int main(int argc, char* argv[]) 
{
	int ret;
	char buffer[40];
	int x;

	x = atoi(argv[1]);
	if (x < 10) {
		memcpy(buffer, argv[2], x * 4);
		if (x == 0x574f4c46) {
			execl("/bin/sh", "sh", NULL);
		}
		ret = 0;
	} 
	else {
		ret = 1;
	}
	return ret;
}