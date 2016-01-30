##Two-Player Command Line Chess
The final project for [the Odin Project](http://www.theodinproject.com/ruby-programming/ruby-final-project)'s Ruby Course. I've got pretty much everything workng  - castling, en passamt, promotion. The UI could use some work, and the code could use some cleanup, but I'll come back to that in a while. I'd like to I'd like to try my hand at the bonus feature they suggested, socket based network play. But for now I'm just happy to have something functional up and running.

To play, navigating to the chess directory and run "ruby main.rb". To save your game at any point, just type SAVE. Moves are in the format:

A1 D6

I found the chess piece characters too small to bother with for now, so I've just done lowercase for white and uppercase for black on the board. To castle, just try moving the king two spaces--if you meet all the criteria, the rook will move automatically. Same for en passant—-just move your pawn and you'll capture the piece if eligible. 