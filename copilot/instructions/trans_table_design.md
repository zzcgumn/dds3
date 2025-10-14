6. Storage and retrieval of position state data in the Transposition Table
Positions stored in the Transposition Table always consist of completed tricks. Positions stored
start at depth=4, then 8,12, and so on. The information stored is information on won cards, the
suit lengths of the hands, the hand to play the leading card in the position and upper and lower
bounds for the number of future tricks to be taken by the side of the player.
Starting from issue 1.1.8, each ”winning cards node” contain all winning cards for one suit after
an idea by Joël Bradmetz. This new solution is faster.
6.1 Transposition Table storing winning card ranks
For the outcome of played tricks, only card ranks that are winning due to their ranks matter.
Assume that the last two tricks of a deal without trumps looks like the following:
Trick 12: Leading hand North plays heart A, East, South and West follow with hearts Q, 9 and 7
respectively.
Trick 13: North then leads spade A, the other hands plays diamonds J, 8,3 in that order.
In trick 12, heart A wins by rank. In trick 13, spade A wins but not by rank.
13
The sequence of cards could have been the following without changing the outcome:
Trick 12: Trick 13: heart A, heart x, heart x, heart x
spade x, diamond x, diamond x, diamond x
where x is any rank below lowest winning rank.
The cards that win by rank are recorded during the search and backed up similarly to the search
value. If a card wins by rank and there are equivalent cards, e.g. only spade A is searched from a
sequence of AKQ, then also the other cards K and Q must be recorded as having won by rank.
The cards winning by rank are stored in the Transposition Table as relative ranks, however any
rank larger than the lowest winning rank in the suit is also stored as ”winning ranks”. Using
relative ranks rather than absolute ranks considerably increases the number of positions that
match this Transposition Table entry.
As an example, assume that there are only 4 cards left in a suit, A, Q, 9, 7 where each hand has
one card in the suit. Then any combination of ranks, e.g. 8, 6, 3, 2 that preserves the relative order
of ranks between hands will cause a match.
In the state position information absolute ranks are used; it is only in the Transposition Table
where the ranks are stored as relatives.
6.2 Backing up the winning ranks
At the search termination, either at the last trick or at a cutoff, the cards that have won by rank are
backed up in the search tree together with the search value. As this information propagates
upwards, it is aggregated with backed up information from other tree branches. At a search
cutoff, MergeMoveData merges the information ( is a union):
(winning ranks of all suits for current depth) =
(winning ranks of all suits for depth - 1) 
(possible winning rank for the current move causing the cutoff)
For each new move not causing cutoff, MergeAllMovesData merges:
(winning ranks of all suits for current depth) =
(winning ranks of all suits for current depth) 
(winning ranks of all suits for depth - 1) 
(possible winning rank for the current move)
6.3 Implementing the Transposition Table
The Transposition Table (TT) can be implemented in a number of ways. Indeed it is
encapsulated as a C++ object, so it can be modified without further implications on DDS.
The basic functional requirement is that it must be possible to store nodes that each cover several
14
actual play positions, and it must be possible to query the TT with a specific play position. is the purpose of keeping track of winning ranks.
This
At the time when a node is stored, the winning ranks for that node are known. At the time when
the TT is queried, the position contains only actual cards, and indeed it could be that there are
several nodes in the TT matching that position. One match will then be more detailed (contain
more winning ranks) than the other.
A position can in principle be characterized and indexed in any way, but it seems practical to
index first on the suit distribution and then on the actual suit cards.
For example, a starting position may consist of
 North holding 3=5=3=2 (3 spades, 5 hearts, 3 diamonds and 2 clubs),
 East holding 4=4=3=2,
 South holding 1=2=4=6, and
 West holding the remaining 5=2=3=3.
We already know that each player starts with 13 cards (or whatever number of tricks is still left to
play at the time), so for each player we can leave out the number of one suit, say clubs. We can
encode this rather loosely with 4 bits per suit, so 12 bits per player. This yields 48 bits for the
whole hand. It would also be possible to enumerate the actual distributions more carefully, but
there are a lot of them. Of course a direct 48-bit or even 32-bit index is impractically large.
In terms of precise cards, the absolute holdings must be converted into relative ones. So if the
players collective still hold the KQT9542, this would be considered the same as AKQJT98,
relatively speaking. Otherwise we don’t get nearly enough matches in the TT.
Furthermore, winning ranks must be taken into account. particular example, then that suit would be considered to hold AKQxxxx.
If only the top 3 ranks matter in this
With this general information, we now describe the data structure that is currently used in DDS.
Storage
In earlier DDS version, the suit distribution was stored in a binary tree with a 48-bit key. This
caused a certain amount of hopping around in memory. The current structure consists of (a) a
hash from 48 bits to 8 bits, followed by (b) a flat list that is searched linearly. For most hands
the number of hash collisions is small. Effectively we trade some storage space for speed.
Specific holdings in a suit are characterized by (a) a bit vector of the (relative) ranks, with 0..3
representing the players North..West, so 2 bits per (relative) rank, and (b) a mask bit vector. If
only the top 3 ranks matter, then only the top 6 bits of the mask vector are non-zero.
Once the exact suit distribution has been found, there is another flat list with a fixed number of
elements (currently 125) corresponding to specific hands. If we run out of space, we overwrite
15
the list cyclically from the beginning. between space and speed.
This too was earlier a tree, leading to the same trade-off
Retrieval
The suit distribution is always exact, never approximate, so the look-up works as above.
The hand look-up could proceed player by player or suit by suit. It makes sense for each
comparison to have a good number of bits (close to 32) in order to cut down on the number of
comparisons. A whole suit can be encoded with 2 bits (player number) times 13 cards for a total
of 26 bits. However, we might be unlucky and start with a suit with very few cards.
In the current implementation of DDS, we create a 32-bit vector corresponding to the top 4 cards
(“Ace”
,
“King”
,
“Queen” and “Jack”, relatively speaking) in each of the four suits. This is more
symmetrical and more selective. If that matches, we compare the next four ranks, then the next
four, and finally the deuce.
When we are looking up a specific holding, we first make these 32-bit vectors for specific
holdings. Then for each position in the TT (for the given distribution), we read out the stored
suit vectors and mask vectors. We apply the mask vectors to the given holdings and compare
with the stored winning ranks.
If everything matches, we check the stored bounds to see whether the node causes a cut-off or
not. The stored upper and lower value bounds are checked against the number of tricks won so
far by the player’s side and the target value. The following conditions are then checked,
assuming that it is the North/South side that is the player’s side:
If the sum of the stored lower value bound and the number of tricks won so far for the player’s
side is equal or larger than target, then target can be reached for the player’s side in the current
position. Search on this depth is terminated and TRUE is returned.
If the sum of the stored upper value bound and the number of tricks won so far for the player’s
side is less than target, then reaching target can be prevented by the opponents to the player’s side
in the current position. Search on this depth is terminated and FALSE is returned.
If instead it is East/West that is the player’s side, the following conditions apply:
If the sum of number of tricks remaining and the number of tricks won so far for the player’s side
minus the upper value bound is equal or larger than target, then target can be reached for the
player’s side in the current position. Search on this depth is terminated and TRUE is returned.
If the sum of number of tricks remaining and the number of tricks won so far for the player’s side
minus the lower value bound is less than target, then reaching target can be prevented by the
opponents to the player’s side in the current position. Search on this depth is terminated and
FALSE is returned.
16
For all other cases, the search continues for the current depth.
The usage of upper and lower value bounds in transposition tables is described in [Chang] and
[Kupferschmid, Helmert].
When the value of the current position is known and it is the end of a trick (except the last),
position state information is collected for storage in the Transposition Table. The ranks of the
backed-up winning cards are converted from absolute to relative.
For each suit, it is determined which winning rank that is lowest. The relative ranks then stored in
the new Transposition Table entry are all ranks above and including the lowest rank, filling out
any ”holes” in the ranks that might have been present.