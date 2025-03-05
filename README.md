# Chess

A console-based chess game built in Ruby.

## Description

This project is a command-line implementation of the classic game of chess. It allows two players to play a complete game of chess with all standard rules including castling, en passant, pawn promotion, and check/checkmate detection.

## Features

- Full chess rule implementation
- Board visualization in the console
- Move validation
- Check and checkmate detection
- Special moves (castling, en passant, pawn promotion)
- Game state saving and loading
- Move history

## Installation

```bash
git clone https://github.com/your-username/chess.git
cd chess
```

## Usage

To start a new game:

```bash
ruby play_chess.rb
```

Follow the on-screen instructions to make moves. Moves are made using algebraic notation (e.g., "e2 e4" moves the piece at e2 to e4).

## Testing

The project uses RSpec for testing. To run the test suite:

```bash
rspec
```
