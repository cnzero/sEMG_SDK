function ArduinoUno_Middle(Hand)
    writePWMDutyCycle(Hand.Uno, Hand.Finger{1}, 1);
    writePWMDutyCycle(Hand.Uno, Hand.Finger{3}, 0.6);