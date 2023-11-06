GPPPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore
ASPARAMS = --32
LDPARAMS = -melf_i386
objects = loader.o kernel.o

%.o: %.cpp
		g++ $(GPPPARAMS) $@ -c $<
%.o: %.s
		as $(ASPARAMS) -o $@ $<

mykernel.bin: linker.ld $(objects)
		ld $(LDPARAMS) -T $< -o $@ $(objects)

iso: mykernel.bin
	mkdir -p isodir/boot/grub
	cat iso.txt > isodir/boot/grub/grub.cfg
	cp mykernel.bin isodir/boot/kernel.bin
	grub-mkrescue -o myos.iso isodir
clean:
	rm -rf isodir
	rm loader.o kernel.o mykernel.bin
all: iso
	qemu-system-i386 -cdrom myos.iso -nographic
