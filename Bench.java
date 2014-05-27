public class Bench {

    private static final int RUN_TIMES = 5;

    public static void main(String args[]) {
        long avg = 0;
        for (int i = 0; i < RUN_TIMES; i++) {
            int[][] board = new int[][] {
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
            long begin = System.currentTimeMillis();
            nextState(board, 0, 0);
            avg += System.currentTimeMillis() - begin;
        }
        System.out.println("Completed in " + avg / RUN_TIMES + "ms.");
    }

    private static boolean isValid(int[][] state, int x, int y) {
        for (int i = 0; i <= 8; i++) {
            if (i != y && state[x][i] == state[x][y]
                    || i != x && state[i][y] == state[x][y]) {
                return false;
            }
        }

        int x_from = (x / 3) * 3;
        int y_from = (y / 3) * 3;
        for (int xx = x_from; xx <= x_from + 2; xx++) {
            for (int yy = y_from; yy <= y_from + 2; yy++) {
                if ((xx != x || yy != y) && state[xx][yy] == state[x][y]) {
                    return false;
                }
            }
        }

        return true;
    }

    private static boolean nextState(int[][] state, int x, int y) {
        if (y == 9) {
            y = 0;
            x++;
        }

        if (x == 9) {
            return true;
        }

        if (state[x][y] != 0) {
            return isValid(state, x, y) && nextState(state, x, y + 1);
        } else {
            for (int i = 1; i <= 9; i++) {
                state[x][y] = i;
                if (isValid(state, x, y) && nextState(state, x, y + 1)) {
                    return true;
                }
            }
        }

        state[x][y] = 0;
        return false;
    }
}

