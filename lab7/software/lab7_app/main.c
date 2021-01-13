// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
//	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x70; //make a pointer to access the PIO block
	volatile unsigned int *KEY_PIO = (unsigned int*)0x50;
	volatile unsigned int *SW_PIO = (unsigned int*)0x60;

	*LED_PIO = 0; //clear all LEDs
	int reset= 0;
	int sum = 0;
	int load = 0;
	while ( (1+1) != 3) //infinite loop
	{
		if (reset == 0 && (*KEY_PIO & 0x1) == 0)
		{
			reset = 1;
			sum = 0;
			load = 0;
			*LED_PIO = sum;
		}
		if (load == 0 && (*KEY_PIO & 0x2) == 0)
		{
			sum = sum + *SW_PIO;
			if (sum > 255)
			{
				sum = sum - 256;
			}
			*LED_PIO = sum;
			load = 1;
		}
		if (reset == 1 && (*KEY_PIO & 0x1) != 0)
		{
			reset = 0;
		}
		if (load == 1 && (*KEY_PIO & 0x2) != 0)
		{
			load = 0;
		}
//		for (i = 0; i < 100000; i++); //software delay
//		*LED_PIO |= 0x1; //set LSB
//		for (i = 0; i < 100000; i++); //software delay
//		*LED_PIO &= ~0x1; //clear LSB
	}
	return 1; //never gets here
}
