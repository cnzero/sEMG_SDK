function ArduinoUno_Grasp(Hand)
    for n=1:5
        writePWMDutyCycle(Hand.Uno, Hand.Finger{n}, .6);
    end