% all(Job#, Criticality, Release time, Processing time, Deadline)
%*
all(1, lo, 0, 3, 10).
all(2, hi, 1, 4, 13).

all(3, lo, 0, 3, 15).
all(4, hi, 3, 4, 25).
*%
#const n = 1.

release(JN, RelT) :- all(JN, _, RelT, _, _).
%protime(JN, ProT) :- all(JN, _, _, ProT, _), not to_schedule(_).
protime(JN, ProT) :- all(JN, _, _, ProT, _).
deadline(JN, DL)  :- all(JN, _, _, _, DL).
%to_schedule(JN)   :- all(JN, hi, _, _, _), n > 1.

% to increase the processing time because of the degradation
%protime(JN, ProT * n) :- to_schedule(JN), all(JN, hi, _, ProT, _).

% ensure that the job starts after the release time
&diff{ 0 -  (JN,ProT) } <= -RelT :- protime(JN, ProT), release(JN, RelT).

% ensure that the job finishes before the deadline
&diff{ (JN,ProT) - 0 } <= DL - ProT :- protime(JN, ProT), deadline(JN, DL).

{seq(JN1, JN2)} :- protime(JN1, ProT1), protime(JN2, ProT2), JN1 < JN2.
 seq(JN2, JN1)  :- protime(JN1, ProT1), protime(JN2, ProT2), JN1 < JN2, 
                   not seq(JN1, JN2).

&diff{ (JN1,ProT1) - (JN2,ProT2) } <= -ProT1 :- seq(JN1, JN2),
                                                protime(JN1, ProT1), protime(JN2, ProT2).
#show.