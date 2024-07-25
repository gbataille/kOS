// SET orbProgradeArrow TO VECDRAWARGS(
//     v(0,0,0),
//     SHIP:prograde:vector:normalized,
//     RED,
//     "prograde",
//     10,
//     TRUE, 0.2, TRUE, TRUE
// ).
// SET orbProgradeArrow:vectorupdater to {RETURN ship:prograde:vector:normalized.}.
// SET srfProgradeArrow TO VECDRAWARGS(
//     v(0,0,0),
//     SHIP:srfprograde:vector:normalized,
//     GREEN,
//     "prograde",
//     10,
//     TRUE, 0.2, TRUE, TRUE
// ).
// SET srfProgradeArrow:vectorupdater to {RETURN ship:srfPrograde:vector:normalized.}.