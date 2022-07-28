# Ballz Gaiden

new bug, trying to make it so that when balls and ball bricks touch the ground, the ground deletes them.
However, this means that Ground can't be a StaticBody, because static body don't have the right methods to handle it.
However, making the ground a kinematicBdoy also breaks the code, since it leads to a lot of weird physics bugs.
Might be best to just turn them all into Area2D.

We can just reimplement all the methods we want
