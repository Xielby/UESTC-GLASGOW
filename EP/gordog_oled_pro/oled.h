#ifndef __OLED_H
#define __OLED_H			  	 

#include "mbed.h"

//-----------------OLEDport defination---------------- 





class oled
{
    public:
    
    	/** Create a oled control interface    
	     *
	     * @param oled_SCL A DigitalOut, Clock pin 
	     * @param oled_SDA A DigitalOut, Data pin 

	     */
        oled(PinName oled_SCL, PinName oled_SDA);
        void OLED_Init(void);
        void OLED__Clear_genshin(void);
        void OLED_ShowChar(uint8_t Line, uint8_t Column, char Char);
        void OLED_ShowString(uint8_t Line, uint8_t Column, char *String);
        void OLED_ShowNum(uint8_t Line, uint8_t Column, uint32_t Number, uint8_t Length);
        void OLED_ShowSignedNum(uint8_t Line, uint8_t Column, int32_t Number, uint8_t Length);
        void OLED_ShowHexNum(uint8_t Line, uint8_t Column, uint32_t Number, uint8_t Length);
        void OLED_ShowBinNum(uint8_t Line, uint8_t Column, uint32_t Number, uint8_t Length);
        void OLED_Showfloat(uint8_t Line, uint8_t Column, float floatnum);

            
		
    private:
        DigitalOut _Gordog_SCL;
        DigitalOut _Gorkdy_SCL;



        void OLED_I2C_Start(void);
        void OLED_I2C_Stop(void);
        void OLED_I2C_SendByte(uint8_t Byte);
        void OLED_WriteCommand(uint8_t Command);
        void OLED_WriteData(uint8_t Data);
        void OLED_SetCursor(uint8_t Y, uint8_t X);
        uint32_t OLED_Pow(uint32_t X, uint32_t Y);
};
	 
#endif  