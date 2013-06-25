# TTT

A simple git-backed Tic Tac Toe game with AI

## Installation

    $ git clone https://github.com/dashkb/ttt.git
    $ cd ttt
    $ rake install

## Usage

    $ ttt create path/to/new/game
    $ cd path/to/new/game
    $ ttt board # shows the board
    $ ttt play [SPACE] # marks SPACE for the next player
                       # space is a1, a2, ... , c3
    $ ttt aiplay # have the computer make the next move

Don't forget to utilize `git branch` and `git reset` to fully analyze the depth of your Tic Tac Toe possibilities.
And of course your games are all nicely summarized in your commit log.
