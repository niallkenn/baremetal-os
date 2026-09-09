#ifndef PROCESSH
#define PROCESSH

#define MAX_PROCESSES 16

typedef enum {
    PROCESS_READY,
    PROCESS_RUNNING,
    PROCESS_BLOCKED,
    PROCESS_TERMINATED
} process_state_t;

typedef struct process_t {
    int pid;
    process_state_t state;
} process_t;

process_t processes[MAX_PROCESSES];
int active_processes = 0;

process_t* process_create(void);
void process_destroy(process_t* process);

#endif