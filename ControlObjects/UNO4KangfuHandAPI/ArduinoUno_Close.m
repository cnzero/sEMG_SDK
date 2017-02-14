function ArduinoUno_Close(Hand)
    for n=1:5
        writePWMDutyCycle(Hand.Uno, Hand.Finger{n}, .6);
    end