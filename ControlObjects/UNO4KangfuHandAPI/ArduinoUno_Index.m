function ArduinoUno_Index(Hand)
    writePWMDutyCycle(Hand.Uno, Hand.Finger{1},0.6);
    writePWMDutyCycle(Hand.Uno, Hand.Finger{2},0.5);
    