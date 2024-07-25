RUNONCEPATH("0:/lib/launch.ks").

PARAMETER targetOrbitAlt IS 90_000.
PARAMETER halfPitchAlt IS 20_000.
PARAMETER maxG IS 2.5.

clearScreen.

countdown().

WAIT UNTIL ship:velocity:surface:mag > 50.
PRINT "Pitching".
LOCK STEERING TO LOOKDIRUP(HEADING(90,(90 - 45 * altitude / halfPitchAlt)):FOREVECTOR,SHIP:FACING:TOPVECTOR).

WHEN (throttle > (maxG * ship:mass * constant:g0 / ship:availablethrust)) THEN {
    PRINT "Throttling down to ${maxG}".
    LOCK throttle to (maxG * ship:mass * constant:g0 / ship:availablethrust).
}

WAIT UNTIL altitude > halfPitchAlt.
LOCK STEERING TO LOOKDIRUP(HEADING(90,45):FOREVECTOR,SHIP:FACING:TOPVECTOR).
PRINT "Mid-pitch. Waiting for prograde to catch up".

WAIT UNTIL (vAng(ship:velocity:surface:vec, heading(90, 45):vector)) < 1.
PRINT "Locking to surface prograde".
LOCK STEERING TO LOOKDIRUP(srfPrograde:forevector,SHIP:FACING:TOPVECTOR).

WHEN (vAng(ship:srfprograde:forevector, ship:prograde:forevector) < 1) THEN {
    PRINT "Locking to orbit prograde".
    LOCK STEERING TO LOOKDIRUP(prograde:forevector,SHIP:FACING:TOPVECTOR).
}

WHEN (eta:apoapsis > 60) THEN {
    PRINT "Throttling down to 1.1".
    lock throttle to (1.1 * ship:mass * constant:g0 / ship:availablethrust).
}


WAIT UNTIL ship:apoapsis > targetOrbitAlt.
PRINT "Just needs circularizing now".
PRINT "DONE".
SAS ON.
