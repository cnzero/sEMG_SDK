function ArduinoUno_Open(Hand)
    for n=1:5
        writePWMDutyCycle(Hand.Uno, Hand.Finger{n}, 0);
    end