# Ballz Gaiden

Current Bug: Game breaks after level 7 or so.
Usually you can't get a ball count over 4 or 5 before it stops working.
really weird.

i think it happens when the level/row text on top and the ball count on the bottom is out of sync.
Like when there is less balls then rows.

also only happens when you expot the game. Works just fine in the editor
NEVERMIND IT HAPPENS IN EDITOR AS WELL

figured it out, it happens because the grounded balls and the number of balls get out of sync, and which means that the rest of the game
can't continue until that desync is fixed