void m(void *param_1,int param_2,char *param_3,int param_4,int param_5)
{
  time_t tvarx;
  
  tvarx = time((time_t *)0x0);
  printf("%s - %d\n",c,tvarx);
  return;
}

undefined4 main(undefined4 param_1,int param_2)
{
  undefined4 *arr1;
  void *varx;
  undefined4 *arr2;
  FILE *__stream;
  
  arr1 = (undefined4 *)malloc(8);
  *arr1 = 1;
  varx = malloc(8);
  arr1[1] = varx;
  arr2 = (undefined4 *)malloc(8);
  *arr2 = 2;
  varx = malloc(8);
  arr2[1] = varx;
  strcpy((char *)arr1[1],*(char **)(param_2 + 4));
  strcpy((char *)arr2[1],*(char **)(param_2 + 8));
  __stream = fopen("/home/user/level8/.pass","r");
  fgets(c,0x44,__stream);
  puts("~~");
  return 0;
}

