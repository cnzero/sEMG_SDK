function ArduinoUno_Rest(Hand)
    writePWMDutyCycle(Hand.Uno, Hand.Finger{1}, 0.3);
    writePWMDutyCycle(Hand.Uno, Hand.Finger{2}, 0.3);
    writePWMDutyCycle(Hand.Uno, Hand.Finger{3}, 0.3);
    writePWMDutyCycle(Hand.Uno, Hand.Finger{4}, 0.3);
    writePWMDutyCycle(Hand.Uno, Hand.Finger{5}, 0.3);