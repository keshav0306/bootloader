#define EI_NIDENT 16
#define Elf32_Half short
#define Elf32_Word int
#define Elf32_Off int
#define Elf32_Addr int

typedef struct {
        unsigned char   e_ident[EI_NIDENT];
        Elf32_Half      e_type;
        Elf32_Half      e_machine;
        Elf32_Word      e_version;
        Elf32_Addr      e_entry;
        Elf32_Off       e_phoff;
        Elf32_Off       e_shoff;
        Elf32_Word      e_flags;
        Elf32_Half      e_ehsize;
        Elf32_Half      e_phentsize;
        Elf32_Half      e_phnum;
        Elf32_Half      e_shentsize;
        Elf32_Half      e_shnum;
        Elf32_Half      e_shstrndx;
} Elf32_Ehdr;

typedef struct {
	Elf32_Word	p_type;		/* Entry type. */
	Elf32_Off	p_offset;	/* File offset of contents. */
	Elf32_Addr	p_vaddr;	/* Virtual address in memory image. */
	Elf32_Addr	p_paddr;	/* Physical address (not used). */
	Elf32_Word	p_filesz;	/* Size of contents in file. */
	Elf32_Word	p_memsz;	/* Size of contents in memory. */
	Elf32_Word	p_flags;	/* Access permission flags. */
	Elf32_Word	p_align;	/* Alignment in memory and file. */
} Elf32_Phdr;

// load the elf image at 0x100000
#define ELF_ADDR 0x100000
#define ELF_STORAGE_OFFSET 512
#define SECTOR_SIZE 512

int load_kernel(){

    // assume the elf image is at ELF_ADDR
    // this code will be in the boot sector
    // i.e somewhere form 0x7c00 to 0x7dff
    // assume protected 32 bit mode

    Elf32_Ehdr * addr = (Elf32_Ehdr *) ELF_ADDR;
    if(addr->e_ident[1] != 'E' && addr->e_ident[2] != 'L' || addr->e_ident[3] != 'F'){
        return 0;
    }

    int num_prog_headers = addr->e_phnum;

    for(int i=0;i<num_prog_headers;i++){
        Elf32_Phdr * phdr = (Elf32_Phdr *)(ELF_ADDR + addr->e_phoff + (i * sizeof(Elf32_Phdr)));
        char * load_at = phdr->p_vaddr;
        char * load_from = ELF_STORAGE_OFFSET + phdr->p_offset; // assume that the offset in the file is sector aligned
        int size = phdr->p_memsz;
        int num_sectors = size / SECTOR_SIZE;
        if(size % SECTOR_SIZE != 0){
            num_sectors++;
        }
        read(load_at, load_from, size);
    }
    

}