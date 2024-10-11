import 'dart:io';
import 'dart:math';

void main() {
  while (true) {
    print("Добро пожаловать в игру Крестики-Нолики!");

    int size = readInt("Введите размер игрового поля (например, 3 для 3x3): ", minValue: 1);

    print("Выберите режим игры:");
    print("1: Игра против другого игрока");
    print("2: Игра против робота");

    int mode = readInt("Ваш выбор: ", minValue: 1, maxValue: 2);

    List<List<String>> board = List.generate(
        size, (_) => List.generate(size, (_) => ' '),
        growable: false);

    String currentPlayer = Random().nextBool() ? 'X' : 'O';
    print("Первым ходит: $currentPlayer");

    bool gameEnded = false;
    while (!gameEnded) {
      printBoard(board);
      if (mode == 1 || (mode == 2 && currentPlayer == 'X')) {
        print("Ход игрока $currentPlayer");
        makeMove(board, currentPlayer);
      } else {
        print("Робот делает ход:");
        makeMoveAI(board, currentPlayer);
      }

      gameEnded = checkWinner(board, currentPlayer) || checkDraw(board);

      if (gameEnded) {
        printBoard(board);
        if (checkWinner(board, currentPlayer)) {
          print("Игрок $currentPlayer выиграл!");
        } else {
          print("Ничья!");
        }
      } else {
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
      }
    }

    String playAgain = readString("Хотите сыграть ещё раз? (y/n): ", ['y', 'n']);
    if (playAgain != 'y') break;
  }
}

int readInt(String prompt, {int? minValue, int? maxValue}) {
  while (true) {
    stdout.write(prompt);
    try {
      int value = int.parse(stdin.readLineSync()!);
      if ((minValue == null || value >= minValue) && (maxValue == null || value <= maxValue)) {
        return value;
      } else {
        print("Пожалуйста, введите число от $minValue до $maxValue.");
      }
    } catch (e) {
      print("Ошибка ввода. Пожалуйста, введите целое число.");
    }
  }
}

String readString(String prompt, List<String> validOptions) {
  while (true) {
    stdout.write(prompt);
    String input = stdin.readLineSync()!.toLowerCase();
    if (validOptions.contains(input)) {
      return input;
    } else {
      print("Пожалуйста, введите одно из следующих значений: ${validOptions.join(', ')}.");
    }
  }
}

void printBoard(List<List<String>> board) {
  for (var row in board) {
    print(row.map((e) => e.isEmpty ? ' ' : e).join(' | '));
    print('-' * (board.length * 4 - 1));
  }
}

void makeMove(List<List<String>> board, String player) {
  while (true) {
    print("Введите номер строки и столбца через пробел (например, 1 2):");
    try {
      List<int> input = stdin.readLineSync()!
          .split(' ')
          .map((e) => int.parse(e) - 1)
          .toList();

      if (input.length != 2) {
        print("Пожалуйста, введите два числа.");
        continue;
      }

      int row = input[0];
      int col = input[1];

      if (row < 0 || col < 0 || row >= board.length || col >= board.length) {
        print("Координаты вне диапазона. Попробуйте снова.");
      } else if (board[row][col] != ' ') {
        print("Эта ячейка уже занята. Попробуйте снова.");
      } else {
        board[row][col] = player;
        break;
      }
    } catch (e) {
      print("Ошибка ввода. Пожалуйста, введите два целых числа.");
    }
  }
}

void makeMoveAI(List<List<String>> board, String player) {
  List<List<int>> availableMoves = [];
  for (int i = 0; i < board.length; i++) {
    for (int j = 0; j < board[i].length; j++) {
      if (board[i][j] == ' ') {
        availableMoves.add([i, j]);
      }
    }
  }

  if (availableMoves.isNotEmpty) {
    var move = availableMoves[Random().nextInt(availableMoves.length)];
    board[move[0]][move[1]] = player;
  }
}

bool checkWinner(List<List<String>> board, String player) {
  int size = board.length;
  for (int i = 0; i < size; i++) {
    if (board[i].every((e) => e == player) ||
        [for (int j = 0; j < size; j++) board[j][i]].every((e) => e == player)) {
      return true;
    }
  }
  if ([for (int i = 0; i < size; i++) board[i][i]].every((e) => e == player) ||
      [for (int i = 0; i < size; i++) board[i][size - i - 1]].every((e) => e == player)) {
    return true;
  }

  return false;
}

bool checkDraw(List<List<String>> board) {
  return board.every((row) => row.every((e) => e != ' '));
}