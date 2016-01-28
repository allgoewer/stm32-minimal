MEMORY {
	rom (rx) : ORIGIN = 0x08000000, LENGTH = 1M
	ram (rwx): ORIGIN = 0x20000000, LENGTH = 128k
}

_size_vector_table = 0x0400;

SECTIONS {
	.vec : {
		_svector = .;
		main.o(vector_table)
		. = _svector + _size_vector_table;
		. = ALIGN(4);
		_evector = .;
	} > rom

	.text : {
		*(.text*)
		*(.rodata*)
	} > rom

	.bss : {
		_sbss = .;
		*(.bss*)
		. = ALIGN(4);
		_ebss = .;
	} > ram

	.data : {
		_sdata_ram = .;
		*(.data*)
		. = ALIGN(4);
		_edata_ram = .;
	} > ram AT > rom

	.stack : {
		_sstack = .;
		. = ORIGIN(ram) + LENGTH(ram);
		. = ALIGN(4);
		_estack = .;
	} > ram
}

_sdata_rom = LOADADDR(.data);
_edata_rom = _sdata_rom + SIZEOF(.data);
