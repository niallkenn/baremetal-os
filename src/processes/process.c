#include <stddef.h>
#include "process.h"

process_t* process_create(void) {
    if (active_processes == MAX_PROCESSES) {
        return NULL;
    }

    process_t* process = &processes[active_processes];

    process->pid = active_processes + 1;
    active_processes++;

    process->state = PROCESS_READY;
    
    return process;
}

void process_destroy(process_t* process) {
    process->state = PROCESS_TERMINATED;
    process->pid = -1;
}