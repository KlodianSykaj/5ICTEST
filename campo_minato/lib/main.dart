import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MinesweeperApp());

class MinesweeperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Minesweeper'),
        ),
        body: Minesweeper(),
      ),
    );
  }
}

class Minesweeper extends StatefulWidget {
  @override
  _MinesweeperState createState() => _MinesweeperState();
}

class _MinesweeperState extends State<Minesweeper> {
  static const rows = 8;
  static const cols = 8;
  static const mineCount = 10;

  List<List<bool>> isMine =
      List.generate(rows, (i) => List.filled(cols, false));
  List<List<bool>> revealed =
      List.generate(rows, (i) => List.filled(cols, false));

  @override
  void initState() {
    super.initState();
    initializeMines();
  }

  void initializeMines() {
    Random random = Random();
    int minesPlaced = 0;
    while (minesPlaced < mineCount) {
      final row = random.nextInt(rows);
      final col = random.nextInt(cols);
      if (!isMine[row][col]) {
        isMine[row][col] = true;
        minesPlaced++;
      }
    }
  }

  int countMinesAround(int row, int col) {
    int count = 0;
    for (int r = row - 1; r <= row + 1; r++) {
      for (int c = col - 1; c <= col + 1; c++) {
        if (r >= 0 && r < rows && c >= 0 && c < cols) {
          if (isMine[r][c]) {
            count++;
          }
        }
      }
    }
    return count;
  }

  void handleGameOver() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (isMine[r][c]) {
          revealed[r][c] = true;
        }
      }
    }

    setState(() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('You hit a mine!'),
            actions: <Widget>[
              TextButton(
                child: Text('Restart'),
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame();
                },
              ),
            ],
          );
        },
      );
    });
  }

  void resetGame() {
    setState(() {
      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          isMine[r][c] = false;
          revealed[r][c] = false;
        }
      }
      initializeMines();
    });
  }

  void revealCell(int row, int col) {
    if (row < 0 ||
        row >= rows ||
        col < 0 ||
        col >= cols ||
        revealed[row][col]) {
      return;
    }

    if (isMine[row][col]) {
      handleGameOver();
      return;
    }

    setState(() {
      revealed[row][col] = true;
    });

    int minesAround = countMinesAround(row, col);
    if (minesAround == 0) {
      for (int r = row - 1; r <= row + 1; r++) {
        for (int c = col - 1; c <= col + 1; c++) {
          revealCell(r, c);
        }
      }
    }

    if (checkWin()) {
      handleGameWon();
    }
  }

  bool checkWin() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!isMine[r][c] && !revealed[r][c]) {
          return false;
        }
      }
    }
    return true;
  }

  void handleGameWon() {
    setState(() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Congratulations!'),
            content: Text('You won the game!'),
            actions: <Widget>[
              TextButton(
                child: Text('Play Again'),
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: List.generate(
          rows,
          (row) => Row(
            children: List.generate(
              cols,
              (col) {
                return GestureDetector(
                  onTap: () => revealCell(row, col),
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: revealed[row][col] ? Colors.brown : Colors.grey,
                    ),
                    child: Center(
                      child: revealed[row][col]
                          ? (isMine[row][col]
                              ? Icon(
                                  Icons.brightness_1,
                                  color: Colors.black,
                                  size: 24.0,
                                )
                              : (countMinesAround(row, col) > 0
                                  ? Text(
                                      countMinesAround(row, col).toString(),
                                      style: TextStyle(fontSize: 18),
                                    )
                                  : null))
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
