void o(void)
{
  system("/bin/sh");
  _exit(1);
}

void n(void)
{
  char local_20c [520];
  
  fgets(local_20c,512,stdin);
  printf(local_20c);
  exit(1);
}

void main(void)
{
  n();
  return;
}