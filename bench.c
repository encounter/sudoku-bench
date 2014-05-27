#define _POSIX_C_SOURCE 200809L

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <inttypes.h>
#include <math.h>
#include <time.h>

typedef uint8_t (*board_t)[9][9];

bool is_valid(board_t state, uint8_t x, uint8_t y);
bool next_state(board_t state, uint8_t x, uint8_t y);
void print_board(board_t state);
uintmax_t current_time_millis();

int main() {
    uint8_t initial_board[9][9] = {
        { 0, 0, 0, 4, 0, 5, 0, 0, 1 },
        { 0, 7, 0, 0, 0, 0, 0, 3, 0 },
        { 0, 0, 4, 0, 0, 0, 9, 0, 0 },
        { 0, 0, 3, 5, 0, 4, 1, 0, 0 },
        { 0, 0, 7, 0, 0, 0, 4, 0, 0 },
        { 0, 0, 8, 9, 0, 1, 0, 0, 0 },
        { 0, 0, 9, 0, 0, 0, 6, 0, 0 },
        { 0, 8, 0, 0, 0, 0, 0, 2, 0 },
        { 4, 0, 0, 2, 0, 0, 0, 0, 0 }
    };
    
    //print_board((board_t) initial_board);
    
    unsigned long elapsed = 0;
    for (uint8_t i = 0; i < 5; i++) {
        board_t state = (board_t) malloc(sizeof(initial_board));
        memcpy(state, initial_board, sizeof(initial_board));
        uintmax_t before = current_time_millis();
        next_state(state, 0, 0);
        elapsed += current_time_millis() - before;
    }
    printf("Completed in %"PRIuPTR"ms.\n", elapsed / 5);
}

bool is_valid(board_t state, uint8_t x, uint8_t y) {
    for (uint8_t i = 0; i <= 8; i++) {
        if ((i != y && (*state)[x][i] == (*state)[x][y])
            || (i != x && (*state)[i][y] == (*state)[x][y])) {
            return false;
        }
    }
    
    uint8_t x_from = (x / 3) * 3;
    uint8_t y_from = (y / 3) * 3;
    for (uint8_t xx = x_from; xx <= x_from + 2; xx++) {
        for (uint8_t yy = y_from; yy <= y_from + 2; yy++) {
            if ((xx != x || yy != y) && (*state)[xx][yy] == (*state)[x][y]) {
                return false;
            }
        }
    }
    
    return true;
}

bool next_state(board_t state, uint8_t x, uint8_t y) {
    if (y == 9) {
        y = 0;
        x++;
    }
    
    if (x == 9) {
        return true;
    }
    
    if ((*state)[x][y] != 0) {
        return is_valid(state, x, y) && next_state(state, x, y + 1);
    } else {
        for (uint8_t i = 1; i <= 9; i++) {
            (*state)[x][y] = i;
            if (is_valid(state, x, y) && next_state(state, x, y + 1)) {
                return true;
            }
        }
    }
    
    (*state)[x][y] = 0;
    return false;
}

void print_board(board_t state) {
    printf("[ ");
    for (uint8_t x = 0; x < 9; x++) {
        if (x > 0)
            printf(" ");
        for (uint8_t y = 0; y < 9; y++) {
            printf(" %d", (*state)[x][y]);
        }
        if (x < 8)
            printf("\n");
    }
    printf(" ]\n");
}

uintmax_t current_time_millis() {
    struct timespec spec;
    clock_gettime(CLOCK_REALTIME, &spec);
    return spec.tv_sec * 1000LL + round(spec.tv_nsec / 1.0e6);
}

