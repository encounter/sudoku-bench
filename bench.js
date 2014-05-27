(function() {
    "use strict";
    
    function isValid(state, x, y) {
      for (var i = 0; i <= 8; i++) {
        if ((i != y && state[x][i] == state[x][y])
            || (i != x && state[i][y] == state[x][y]))
            return false;
      }
      
      var x_from = Math.floor(x / 3) * 3;
      var y_from = Math.floor(y / 3) * 3;
      for (var xx = x_from; xx <= x_from + 2; xx++) {
        for (var yy = y_from; yy <= y_from + 2; yy++) {
            if ((xx != x || yy != y) && (state[xx][yy] == state[x][y]))
                return false;
        }
      }
      
      return true;
    }
    
    function nextState(state, x, y) {
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
            for (var i = 1; i <= 9; i++) {
                state[x][y] = i;
                if (isValid(state, x, y) && nextState(state, x, y + 1))
                    return true;
            }
        }
        
        state[x][y] = 0;
        return false;
    }
    
    function deepCopy(o) {
      return JSON.parse(JSON.stringify(o));
    }
    
    var board = [
      [ 0, 0, 0, 4, 0, 5, 0, 0, 1 ],
      [ 0, 7, 0, 0, 0, 0, 0, 3, 0 ],
      [ 0, 0, 4, 0, 0, 0, 9, 0, 0 ],
      [ 0, 0, 3, 5, 0, 4, 1, 0, 0 ],
      [ 0, 0, 7, 0, 0, 0, 4, 0, 0 ],
      [ 0, 0, 8, 9, 0, 1, 0, 0, 0 ],
      [ 0, 0, 9, 0, 0, 0, 6, 0, 0 ],
      [ 0, 8, 0, 0, 0, 0, 0, 2, 0 ],
      [ 4, 0, 0, 2, 0, 0, 0, 0, 0 ]
    ];
    
    // Pre-optimization
    var boardTest = deepCopy(board);
    nextState(boardTest, 0, 0);
    
    var runTimes = 5;
    var elapsed = 0;
    for (var i = 0; i < runTimes; i++) {
      var state = deepCopy(board);
      var begin = new Date().getTime();
      nextState(state, 0, 0);
      elapsed += new Date().getTime() - begin;
    }
    console.log("Completed in " + Math.floor(elapsed / runTimes) + "ms.");
})();
