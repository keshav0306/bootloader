#include <stdio.h>
#include <stdint.h>

int main() {
    uint32_t eax, ebx, ecx, edx;

    // Set EAX to 0x7 and ECX to 0 to query extended features
    eax = 0x7;
    ecx = 0;

    // Execute CPUID instruction
    __asm__ volatile("cpuid"
                     : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx)
                     : "a" (eax), "c" (ecx)
                     );

    // Check for CLWB support
    if ((ebx & (1 << 24)) != 0) {
        printf("CLWB instruction is supported\n");
    } else {
        printf("CLWB instruction is not supported\n");
    }

    return 0;
}



