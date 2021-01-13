/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000100;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *  
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *  
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}






uint RotWord(uint word){
	return (word << 8 & 0xFFFFFF00) | (word >> 24 & 0x000000FF);
}

uint SubWord(uint word){
	uchar* temp = (uchar*) &word;
	*temp 		= aes_sbox[(uint) *temp];
	*(temp + 1) = aes_sbox[(uint) *(temp + 1)];
	*(temp + 2) = aes_sbox[(uint) *(temp + 2)];
	*(temp + 3) = aes_sbox[(uint) *(temp + 3)];
	return word;
}

void KeyExpansion(uchar *key, uint *w){
	uint temp;
	int i = 0;
	while (i < 4){
		w[i] = (key[i] << 24) | (key[4 + i] << 16) | (key[8 + i] << 8) | (key[12 + i]);
		i++;
	}
	i = 4;
	while (i < 4 * 11){
		temp = w[i-1];
		if (i % 4 == 0){
			temp = SubWord(RotWord(temp)) ^ Rcon[i/4];
		}
		w[i] = w[i-4] ^ temp;
		i++;
	}
}


void AddRoundKey(uchar* state, uint* key){
	int i;
	for (i= 0; i <= 3;i++){
		int j;
		for (j= 0; j <= 3;j++)
			state[i*4+j] ^= ((key[j]>>((3-i)*8)) & 0xFF);
	}
}



void SubBytes(uchar *state){
	int i;
	for(i = 0; i <= 15; i++){
		uint temp = (state[i] >> 4)*16 + (state[i]& 0x0F);
		state[i] = aes_sbox[temp];
	}
}

void ShiftRows(uchar *state){
	int i;
	for (i = 1; i <=3; i++){
		uchar t[4];
		int j;
		for (j = 0; j<=3; j++)
			t[j] = state[i*4+(i+j)%4];
		for (j = 0; j<=3; j++)
			state[i*4 + j] = t[j];
	}
}


uchar multi_2(uchar a){
	uchar res = a <<1;
	if(a & 0x80)
		res ^= 0x1b;
	return res;
}

uchar multi_3(uchar a){
	return (multi_2(a) ^ a);
}

void MixColumns(uchar *state){
	uchar b[16];
	int i ;
	for (i = 0; i <=3; i++){
		b[i] = multi_2(state[i]) ^ multi_3(state[4+i]) ^ state[8+i] ^ state[12+i];
		b[4+i] = state[i] ^ multi_2(state[4+i]) ^ multi_3(state[8+i]) ^ state[12+i];
		b[8+i] = state[i] ^ state[4+i] ^ multi_2(state[8+i]) ^ multi_3(state[12+i]);
		b[12+i] = multi_3(state[i]) ^ state[4+i] ^ state[8+i] ^ multi_2(state[12+i]);
	}
	for (i = 0; i <=15; i++)
		state[i] = b[i];
}



/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
 
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	// Implement this function
	uchar state[16],KeySchedule[16];
	uint w[44];
	int i;
	for (i = 0; i <= 15; i++){
		//state = msg_ascii.T
		state[(i%4)*4 +i/4] = charsToHex(msg_ascii[2*i], msg_ascii[2*i+1]);
		KeySchedule[(i%4)*4 +i/4] = charsToHex(key_ascii[2*i], key_ascii[2*i+1]);
	}
	
	KeyExpansion(KeySchedule,w);


	AddRoundKey(state, w);
	int round;
	for(round = 1; round <= 9; round ++){
		SubBytes(state);
		ShiftRows(state);
		MixColumns(state);
		AddRoundKey(state, w+round*4); //w[round*4, (round+1)*4-1]
	}
	SubBytes(state);
	ShiftRows(state);
	AddRoundKey(state, w+10*4); //w[10*4, (10+1)*4-1]
	
	for(i = 0; i <= 3; i++){
		msg_enc[i] = (state[i] << 24) | (state[4 + i] << 16) | (state[8 + i] << 8) | (state[12 + i]);
		key[i] = (KeySchedule[i] << 24) | (KeySchedule[4 + i] << 16) | (KeySchedule[8 + i] << 8) | (KeySchedule[12 + i]);
	}

//	AES_PTR[0] = w[40];
//	AES_PTR[1] = w[41];
//	AES_PTR[2] = w[42];
//	AES_PTR[3] = w[43];

/*	AES_PTR[10] = 0xDEADBEEF;
	if (AES_PTR[10] != 0xDEADBEEF)
		printf("Error!");
		*/
}




/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
//	// Implement this function
//	AES_PTR[14] = 0;
//	AES_PTR[15] = 0;
//	int i;
//	for(i = 0; i <= 3; i++)
//		AES_PTR[i] = key[i];
//	for(i = 0; i <= 3; i++)
//		AES_PTR[4+i] = msg_enc[i];
//	AES_PTR[14] = 1;
//	for(;;)
//		if(AES_PTR[15])
//			break;
//	for(i = 0; i <=3; i++)
//		msg_dec[i] = AES_PTR[8+i];
	AES_PTR[14] = 0;
	AES_PTR[15] = 0;
	AES_PTR[0] = key[3];
	AES_PTR[1] = key[2];
	AES_PTR[2] = key[1];
	AES_PTR[3] = key[0];
	AES_PTR[4] = msg_enc[3];
	AES_PTR[5] = msg_enc[2];
	AES_PTR[6] = msg_enc[1];
	AES_PTR[7] = msg_enc[0];

	AES_PTR[14] = 1;

	//wait for the hardware to finish decoding
	while(AES_PTR[15] == 0){

	}

	msg_dec[0] = AES_PTR[11];
	msg_dec[1] = AES_PTR[10];
	msg_dec[2] = AES_PTR[9];
	msg_dec[3] = AES_PTR[8];

	AES_PTR[14] = 0;
	AES_PTR[15] = 0;
	return;
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);

	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}
