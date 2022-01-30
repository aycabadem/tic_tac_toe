import 'board_tile.dart';
import 'tile_state.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TileState> _boardState = List.generate(9, (index) => TileState.EMPTY);
  TileState _currentTurn = TileState.CROSS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Stack(
          children: [
            Image.asset('images/a1.png'),
            _boardTiles(),
          ],
        ),
      ),
    );
  }

  Widget _boardTiles() {
    final boardDimension = MediaQuery.of(context).size.width;
    final tileDimension = boardDimension / 3;

    return Container(
        width: boardDimension,
        height: boardDimension,
        child: Column(
            children: chunk(_boardState, 3).asMap().entries.map((entry) {
          final chunkIndex = entry.key;
          final tileStateChunk = entry.value;

          return Row(
            children: tileStateChunk.asMap().entries.map((innerEntry) {
              final innerIndex = innerEntry.key;
              final tileState = innerEntry.value;
              final tileIndex = (chunkIndex * 3) + innerIndex;

              return BoardTile(
                tileState: tileState,
                dimension: tileDimension,
                onPressed: () => _updateTileStateForIndex(tileIndex),
              );
            }).toList(),
          );
        }).toList()));
  }

  void _updateTileStateForIndex(int selectedIndex) {
    if (_boardState[selectedIndex] == TileState.EMPTY) {
      setState(() {
        _boardState[selectedIndex] = _currentTurn;
        _currentTurn = _currentTurn == TileState.CROSS
            ? TileState.CIRCLE
            : TileState.CROSS;
      });

      final TileState? winner = _findWinner();
      if (winner != null) {
        print('Winner is: $winner');
        _showWinnerDialog(winner);
      }
    }
  }

  TileState? _findWinner() {
    TileState? Function(int, int, int) winnerForMatch = (a, b, c) {
      if (_boardState[a] != TileState.EMPTY) {
        if ((_boardState[a] == _boardState[b]) &&
            (_boardState[b] == _boardState[c])) {
          return _boardState[a];
        }
      }
      return null;
    };

    final checks = [
      winnerForMatch(0, 1, 2),
      winnerForMatch(3, 4, 5),
      winnerForMatch(6, 7, 8),
      winnerForMatch(0, 3, 6),
      winnerForMatch(1, 4, 7),
      winnerForMatch(2, 5, 8),
      winnerForMatch(0, 4, 8),
      winnerForMatch(2, 4, 6),
    ];

    TileState? winner;
    for (int i = 0; i < checks.length; i++) {
      if (checks[i] != null) {
        winner = checks[i];
        break;
      }
    }

    return winner;
  }

  void _showWinnerDialog(TileState tileState) {
    // final context = navigatorKey.currentState!.overlay!.context;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Winner'),
            content: Image.asset(tileState == TileState.CROSS
                ? 'images/a3.png'
                : 'images/a2.png'),
            actions: [
              TextButton(
                  onPressed: () {
                    _resetGame();
                    Navigator.of(context).pop();
                  },
                  child: Text('New Game'))
            ],
          );
        });
  }

  void _resetGame() {
    setState(() {
      _boardState = List.filled(9, TileState.EMPTY);
      _currentTurn = TileState.CROSS;
    });
  }
}
