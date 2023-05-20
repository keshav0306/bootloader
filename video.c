struct RSDPDescriptor{
    char signature[8];
    char checksum;
    char OEMID[6];
    char revision;
    char * rsdtAddress;

    int length;
    long long xsdtAddress;
    char extendedChecksum;
    char reserved[3];
} __attribute__ ((packed));

struct sdtHeader{
    char signature[4];
    int length;
    char revision;
    char checksum;
    char OEMID[6];
    char OEMtableID[8];
    int OEMRevision;
    int creatorID;
    int creatorRevision;
} __attribute__ ((packed));

struct GenericAddressStructure
{
  char AddressSpace;
  char BitWidth;
  char BitOffset;
  char AccessSize;
  long long Address;
};

struct fadt
{
    struct   sdtHeader header;
    int FirmwareCtrl;
    int Dsdt;

    char  Reserved;
 
    char  PreferredPowerManagementProfile;
    short SCI_Interrupt;
    int SMI_CommandPort;
    char  AcpiEnable;
    char  AcpiDisable;
    char  S4BIOS_REQ;
    char  PSTATE_Control;
    int PM1aEventBlock;
    int PM1bEventBlock;
    int PM1aControlBlock;
    int PM1bControlBlock;
    int PM2ControlBlock;
    int PMTimerBlock;
    int GPE0Block;
    int GPE1Block;
    char  PM1EventLength;
    char  PM1ControlLength;
    char  PM2ControlLength;
    char  PMTimerLength;
    char  GPE0Length;
    char  GPE1Length;
    char  GPE1Base;
    char  CStateControl;
    short WorstC2Latency;
    short WorstC3Latency;
    short FlushSize;
    short FlushStride;
    char  DutyOffset;
    char  DutyWidth;
    char  DayAlarm;
    char  MonthAlarm;
    char  Century;
 
    // reserved in ACPI 1.0; used since ACPI 2.0+
    short BootArchitectureFlags;
 
    char  Reserved2;
    int Flags;
 
    // 12 byte structure; see below for details
    struct GenericAddressStructure ResetReg;
 
    char  ResetValue;
    char  Reserved3[3];
 
    // 64bit pointers - Available on ACPI 2.0+
    long long                X_FirmwareControl;
    long long                X_Dsdt;
 
    struct GenericAddressStructure X_PM1aEventBlock;
    struct GenericAddressStructure X_PM1bEventBlock;
    struct GenericAddressStructure X_PM1aControlBlock;
    struct GenericAddressStructure X_PM1bControlBlock;
    struct GenericAddressStructure X_PM2ControlBlock;
    struct GenericAddressStructure X_PMTimerBlock;
    struct GenericAddressStructure X_GPE0Block;
    struct GenericAddressStructure X_GPE1Block;
} __attribute__ ((packed)) ;

int k = 8;

int look_for_ebda(){
    char * addr = 0xE0000;
    char * video_addr = 0xb8004;
    *(video_addr) = 'Y';
    *(video_addr + 1) = 0xA; 

    for(;;){
        if(*addr == 'R' && *(addr + 1) == 'S' && *(addr + 2) == 'D' && *(addr + 3) == ' '){
            *(video_addr) = 'R';
            *(video_addr + 1) = 0xA; 
            break;
        }
        addr += 4;
    }
    struct RSDPDescriptor * rsdp = (struct RSDPDescriptor *)addr;
    if(rsdp->revision == 0){
        *(video_addr) = 'Z';
        *(video_addr + 1) = 0xA;
    }
    struct sdtHeader * rsdt = (struct sdtHeader *) rsdp->rsdtAddress;
    if(rsdt->signature[0] == 'R' && rsdt->signature[1] == 'S' && rsdt->signature[3] == 'T'){
        *(video_addr) = 'B';
        *(video_addr + 1) = 0xA;
        // found the rsdp table
        // now we can find other system descriptor tables (SDT)
        // get the number of tables the rsdt is pointing to
        int num = (rsdt->length - sizeof(struct sdtHeader)) / 4;
        int * rsdtPointerEnd = rsdp->rsdtAddress + sizeof(struct sdtHeader);
        for(int i=0;i<num;i++){
            char * addrOfSdt = (char *)*rsdtPointerEnd;
            struct sdtHeader * heading = (struct sdtHeader *) addrOfSdt;
            *(video_addr) = heading->signature[0];
            if(heading->signature[0] == 'F' && heading->signature[1] == 'A'){
                *(video_addr) = '4';
                *(video_addr + 1) = 0xA;
                struct fadt * fadtPtr = (struct fadt *) (addrOfSdt);
                int pm1cnt = (fadtPtr->PM1aControlBlock);
                // short addrcnt = (short)pm1cnt;
                // asm volatile("outw 0x2001, %0" : "=d" (addrcnt));
                int a = 5;
                // if(pm1cnt == 0){
                    *(video_addr) = '1';
                    *(video_addr + 1) = 0xA;
                // }
                // for(;;){
                    if(k >= 5){
                    *(video_addr) = 48 + k;
                    k++;
                    k %= 10;
                    }
                    while(1){

                    }
                // }
            }
            rsdtPointerEnd += 4;
        }
    }
    asm volatile("hlt");
}