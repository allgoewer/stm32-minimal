typedef unsigned int uint32_t;

#define RRC_AHB1ENR	(*(volatile uint32_t *) 0x40023830)

#define GPIOD_BASE	(0x40020C00)
#define GPIOD_MODER	(*(volatile uint32_t *) (GPIOD_BASE + 0x00))
#define GPIOD_ODR	(*(volatile uint32_t *) (GPIOD_BASE + 0x14))

#define LED_PATTERN (1<<15 | 1<<14 | 1<<13 | 1<<12)

/* ram addresses, 4-byte aligned */
extern uint32_t _sstack, _estack;
extern uint32_t _sdata_ram, _edata_ram;
extern uint32_t _sbss, _ebss;
/* rom addresses, 4-byte aligned */
extern uint32_t _svector, _evector;
extern uint32_t _sdata_rom, _edata_rom;

void main(void)
{
	uint32_t *src, *dst;

	/* copy data section to ram */
	src = &_sdata_rom;
	dst = &_sdata_ram;
	while (dst < &_edata_ram) {
		*dst++ = *src++;
	}

	/* zero out bss section in ram */
	dst = &_sbss;
	while (dst < &_ebss) {
		*dst++ = 0;
	}

	/* enable gpio PORTD clock */
	RRC_AHB1ENR |= 1<<3;
	/* set gpios D12-D15 as output */
	GPIOD_MODER |= 1<<30 | 1<<28 | 1<<26 | 1<<24;
	/* set gpios D12-D15 high */
	GPIOD_ODR |= LED_PATTERN;

	for (;;) {
		for (int i = 0; i < 1000000; i++) {
			asm("nop");
		}
		GPIOD_ODR ^= LED_PATTERN;
	}
}

void nmi_handler(void)
{
	for (;;);
}

void hardfault_handler(void)
{
	for (;;);
}

uint32_t *vectors[] __attribute__ ((section("vector_table")))= {
	(uint32_t *) &_estack,
	(uint32_t *) main,
	(uint32_t *) nmi_handler,
	(uint32_t *) hardfault_handler
};
