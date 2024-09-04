void p(char *param_1)
{
	printf(param_1);
	return;
}

void n(void)
{
	char local_20c [520];
	
	fgets(local_20c,0x200,stdin);
	p(local_20c);
	if (m == 16930116)
	{
		system("/bin/cat /home/user/level5/.pass");
	}
	return;
}

void main(void)
{
	n();
	return;
}