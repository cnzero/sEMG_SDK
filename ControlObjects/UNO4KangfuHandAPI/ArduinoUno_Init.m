function Hand = ArduinoUno_Init()
    Hand.Uno = arduino();
    
    % Pin Macros
    Hand.Finger{1} = 'D3';
    Hand.Finger{2} = 'D5';
    Hand.Finger{3} = 'D6';
    Hand.Finger{4} = 'D9';
    Hand.Finger{5} = 'D10';
    Hand.LimitMax = 0.8;
    Hand.LimitMin = 0.2;
    
    % Configure All Finger pins as 'PWM'
    
%     for n=1:5
%         configurePin(Hand.Uno, Hand.Finger{n}, 'PWM');
%         writePWMDutyCycle(Hand.Uno, Hand.Finger{n}, 0.8);
%     end

    % configure pins as PWM outputs
    for n=1:5
        configurePin(Hand.Uno, Hand.Finger{n}, 'PWM');
    end