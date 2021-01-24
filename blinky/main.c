#include <stdbool.h>
#include "nrf_delay.h"
#include "boards.h"

#define GREEN_LED 0
#define RED_LED 1
#define BLUE_LED 2

int main()
{
    UNUSED_VARIABLE(GREEN_LED);
    UNUSED_VARIABLE(BLUE_LED);

    bsp_board_init(BSP_INIT_LEDS);

    while (true)
    {
        bsp_board_led_invert(RED_LED);
        nrf_delay_ms(1000);
    }
}
