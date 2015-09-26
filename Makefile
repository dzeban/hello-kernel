AS := nasm # Deal with it
ASFLAGS := -f elf32 # ELF binary in multiboot format ... mmm ... yummy

LD := ld
LDFLAGS := -melf_i386
LDFILE := link.ld

MKRESCUE := grub2-mkrescue # On your system it might be called differently

all: kernel

kernel: kernel.o 
	$(LD) $(LDFLAGS) -T $(LDFILE) $< -o $@

kernel.o: kernel.S
	$(AS) $(ASFLAGS) $< -o $@

iso: kernel
	mkdir -p isodir/boot/grub
	cp kernel isodir/boot/
	cp grub.cfg isodir/boot/grub
	$(MKRESCUE) -o hello-kernel.iso isodir

iso2: kernel
	cp kernel isodir/boot/
	genisoimage -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -A os -input-charset utf8 -quiet -boot-info-table -o os.iso isodir

clean:
	rm -f *.o *.iso kernel isodir/boot/kernel 
