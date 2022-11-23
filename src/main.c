
#include "gd32f4xx.h"
#include "gd32f427r_start.h"
#include "systick.h"

int main(void)
{  
    gd_eval_led_init(LED1);
    
    systick_config();
    
    while(1){

        gd_eval_led_on(LED1);
        delay_1ms(500);


        gd_eval_led_off(LED1);
        delay_1ms(500);
    }
}