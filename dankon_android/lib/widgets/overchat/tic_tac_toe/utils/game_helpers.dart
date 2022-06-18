class GameHelpers {
  static Map<String, int> getDiagStartPoint(int x, int y) {

    int startX = x;
    int startY = y;

    while(startX > 0 && startY > 0) {
      startX--;
      startY--;
    }

    return {
      "x": startX,
      "y": startY
    };
  }

  static Map<String, int> getRDiagStartPoint(int boardSize, int x, int y) {
    int startX = x;
    int startY = y;

    while (startX > 0 && startY < boardSize - 1) {
      startX--;
      startY++;
    }

    return {
      "x": startX,
      "y": startY
    };
  }
}