RUNONCEPATH("0:/lib/launch.ks").

PARAMETER targetOrbitAlt IS 100_000.
PARAMETER halfPitchAlt IS 15_000.
PARAMETER maxG IS 2.5.

// TODO - staging
// TODO - heading
// TODO - if thrust not enough
// TODO - circularisation
// TODO - exec manoeuver
// TODO - try non forced GT
// TODO - handle asparagus staging

clearScreen.

countdown().

// WAIT UNTIL ship:velocity:surface:mag > 50.
// PRINT "Starting to pitch".
// LOCK STEERING TO LOOKDIRUP(HEADING(90,(90 - 45 * altitude / halfPitchAlt)):FOREVECTOR,SHIP:FACING:TOPVECTOR).
// wait 10.
// PRINT "Locking pitched attitude".
// LOCK STEERING TO LOOKDIRUP(ship:facing:forevector,SHIP:FACING:TOPVECTOR).

WHEN ship:velocity:surface:mag > 50 THEN {
    PRINT "Starting to pitch".
    LOCK STEERING TO LOOKDIRUP(HEADING(90,(90 - 45 * altitude / halfPitchAlt)):FOREVECTOR,SHIP:FACING:TOPVECTOR).
}

WHEN (vAng(UP:vector, ship:velocity:surface:vec)) > 10 THEN {
    PRINT "Locking to surface prograde".
    LOCK STEERING TO LOOKDIRUP(srfPrograde:forevector,SHIP:FACING:TOPVECTOR).
}

// WAIT UNTIL (vAng(ship:velocity:surface:vec, ship:srfprograde:forevector)) < 1.
// PRINT "Locking to surface prograde".
// LOCK STEERING TO LOOKDIRUP(srfPrograde:forevector,SHIP:FACING:TOPVECTOR).

WHEN (vAng(ship:srfprograde:forevector, ship:prograde:forevector) < 2) THEN {
    PRINT "Locking to orbit prograde".
    LOCK STEERING TO LOOKDIRUP(prograde:forevector,SHIP:FACING:TOPVECTOR).
}

when stage:deltav:current < 1 THEN {
    lock throttle to 1.
    PRINT "Staging".
    STAGE.
    return true.
}

set apoEtaPid to pidLoop(1, 0, 0, 0.1, maxG, 0.1).
set apoEtaPid:setpoint to 60.
clearScreen.
until (ship:orbit:apoapsis > targetOrbitAlt) {
    Print stage:deltav:current at (0,0).
    lockTwr(apoEtaPid:update(time:seconds, eta:apoapsis)).
    wait 0.
}

print "meco".
lock throttle to 0.

WAIT UNTIL ship:apoapsis > targetOrbitAlt.
PRINT "Just needs circularizing now".
PRINT "DONE".
SAS ON.
