RUNONCEPATH("0:/lib/ship.ks").

GLOBAL FUNCTION countdown {
   // Countdown beeps
   SET voice to getVoice(0).
   SET voiceTickNote to NOTE(480, 0.1).
   SET voiceTakeOffNote to NOTE(720, 0.5).

   SAS OFF.
   PRINT "5".
   voice:PLAY(voiceTickNote).
   WAIT 1. 
   PRINT "4".
   voice:PLAY(voiceTickNote).
   WAIT 1. 
   PRINT "3".
   voice:PLAY(voiceTickNote).
   WAIT 0.5.
   LOCK STEERING to UP + R(0, 0, 180).
   PRINT "Locking attitude control.".
   WAIT 0.5. 
   PRINT "2".
   voice:PLAY(voiceTickNote).
   WAIT 0.5. 
   LOCK THROTTLE to 1.
   WAIT 0.5.
   PRINT "Throttle to full.".
   PRINT "1".
   voice:PLAY(voiceTickNote).
   PRINT "IGNITION".
   STAGE.

   IF ship:velocity:surface:mag < 1 {
      // means it's clamped
      WAIT UNTIL stage:ready.
      if maxTwr() < 1.2 {
         // Motor needs to warm up?
         WAIT 1.
      }
      if maxTwr() > 1.2 {
         PRINT "Releasing".
         STAGE.
      }
   }

   IF maxTwr() < 1.2 {
      PRINT " ".
      PRINT "Subnominal thrust detected.".
      WAIT 1.
      PRINT "Scrub launch.".
      PRINT " ".
   } ELSE {
      voice:PLAY(voiceTakeOffNote).  
      PRINT "LAUNCH!".
   }
   WAIT 2.
}