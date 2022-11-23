#工程的名称及最后生成文件的名字
TARGET = gd32f427_example

#设定临时性环境变量
export CC             = arm-none-eabi-gcc           
export AS             = arm-none-eabi-as
export LD             = arm-none-eabi-ld
export OBJCOPY        = arm-none-eabi-objcopy

#读取当前工作目录
TOP=$(shell pwd)

#设定包含文件目录
INC_FLAGS= -I $(TOP)/gd_libs/GD32F4xx/Firmware/CMSIS  \
           -I $(TOP)/gd_libs/GD32F4xx/Firmware/CMSIS/GD/GD32F4xx/Include  \
           -I $(TOP)/gd_libs/GD32F4xx/Firmware/GD32F4xx_standard_peripheral/Include  \
           -I $(TOP)/inc  \

CFLAGS +=  -W -Wall -mcpu=cortex-m4 -mthumb
CFLAGS +=  -ffunction-sections -fdata-sections
CFLAGS +=  -D GD32F427 -D USE_STDPERIPH_DRIVER
CFLAGS +=   $(INC_FLAGS) -Os -g -std=gnu11

ASMFLAGS = -mthumb -mcpu=cortex-m4 -g -Wa,--warn 

LDFLAGS += -mthumb -mcpu=cortex-m4
LDFLAGS += -Wl,--start-group -lc -lm -Wl,--end-group -specs=nosys.specs -static -Wl,-cref,-u,Reset_Handler -Wl,-Map=Project.map -Wl,--gc-sections -Wl,--defsym=malloc_getpagesize_P=0x80

LD_PATH = -T $(TOP)/ldscripts/gd32f425_427_xK_flash.ld

C_SRC=$(shell find ./src -name '*.c')  
C_SRC+=$(shell find ./gd_libs/GD32F4xx/Firmware/GD32F4xx_standard_peripheral -name '*.c')  
C_SRC+=$(shell find ./gd_libs/GD32F4xx/Firmware/CMSIS -name '*.c')  
C_OBJ=$(C_SRC:%.c=%.o)          



ASM_SRC=$(TOP)/gd_libs/GD32F4xx/Firmware/CMSIS/GD/GD32F4xx/Source/GCC/startup_gd32f407_427.s 
ASM_OBJ=$(ASM_SRC:%.s=%.o)  

.PHONY: all clean update      

all:$(C_OBJ) $(ASM_OBJ)
	echo $(C_SRC)
	$(CC) $(C_OBJ) $(ASM_OBJ) $(LD_PATH) -o $(TARGET).elf $(LDFLAGS) 
	$(OBJCOPY) $(TARGET).elf  $(TARGET).bin -Obinary 
	$(OBJCOPY) $(TARGET).elf  $(TARGET).hex -Oihex

$(C_OBJ):%.o:%.c
	$(CC) -c $(CFLAGS) -o $@ $<
$(ASM_OBJ):%.o:%.s
	$(CC) -c $(ASMFLAGS) -o $@ $<

clean:
	rm -f $(shell find ./ -name '*.o')
	rm -f $(shell find ./ -name '*.d')
	rm -f $(shell find ./ -name '*.map')
	rm -f $(shell find ./ -name '*.elf')
	rm -f $(shell find ./ -name '*.bin')
	rm -f $(shell find ./ -name '*.hex')

 


 










