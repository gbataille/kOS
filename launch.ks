RUNONCEPATH("0:/lib/launchUtils.ks").
RUNONCEPATH("0:/lib/ship.ks").

PARAMETER targetHeading IS 0.
PARAMETER targetOrbitAltKm IS 100.
PARAMETER halfPitchAltKm IS 15.
PARAMETER maxG IS 2.5.
PARAMETER fairingDeployAltKm IS 60.

// TODO - AG5 based on Q (pressure)
// TODO - if thrust not enough (check the PID error, it should decrease)
// TODO - circularisation
// TODO - exec manoeuver
// TODO - handle asparagus staging
// TODO - keep steering control longer to control heading

SET targetOrbitAlt TO targetOrbitAltKm * 1000.
SET halfPitchAlt TO halfPitchAltKm * 1000.
SET fairingDeployAlt TO fairingDeployAltKm * 1000.

clearScreen.

countdown().

WHEN ship:velocity:surface:mag > 50 THEN {
    PRINT "Starting to pitch".
    LOCK STEERING TO LOOKDIRUP(HEADING(90 + targetHeading,(90 - 45 * altitude / halfPitchAlt)):FOREVECTOR,SHIP:FACING:TOPVECTOR).
}

WHEN (vAng(UP:vector, ship:velocity:surface:vec)) > 20 THEN {
    PRINT "Locking to surface prograde".
    LOCK STEERING TO LOOKDIRUP(srfPrograde:forevector,SHIP:FACING:TOPVECTOR).
}

WHEN (vAng(ship:srfprograde:forevector, ship:prograde:forevector) < 2) THEN {
    PRINT "Locking to orbit prograde".
    LOCK STEERING TO LOOKDIRUP(prograde:forevector,SHIP:FACING:TOPVECTOR).
}

WHEN stage:deltav:current < 1 THEN {
    lock throttle to 1.
    PRINT "Staging".
    STAGE.
    return true.
}

WHEN ship:altitude > fairingDeployAlt THEN {
    TOGGLE AG5.
}

set apoEtaPid to pidLoop(1, 0, 0.2, 0.5, maxG, 0.05).
set apoEtaPid:setpoint to 60.
clearScreen.

set tH TO terminal:HEIGHT.
set tW TO terminal:WIDTH.
set tStart TO tH - 6. // Do not use the last console line

until (ship:orbit:apoapsis > targetOrbitAlt) {
    Print "--------------------------------------":padright(tW) at (0,tStart).
    Print ("Stage dV:":Padright(20) + stage:deltav:current):padright(tW) at (0, tStart + 1).
    Print ("Current TWR":Padright(20) + currentTwr()):padright(tW) at (0, tStart + 2).
    Print ("Q (kPa)":Padright(20) + ship:q * constant:atmtokpa):padright(tW) at (0, tStart + 3).
    Print "--------------------------------------":padright(tW) at (0,tStart + 4).

    SET targetTwr TO min(apoEtaPid:update(time:seconds, eta:apoapsis), maxTwr()).
    lockTwr(targetTwr).
    wait 0.
}

print "meco".
lock throttle to 0.
PRINT "Just needs circularizing now".
RUN circat.
PRINT "DONE".
SAS ON.
