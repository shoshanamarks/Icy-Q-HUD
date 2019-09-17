joy = vrjoystick(1);
statThrust = 8100;
while 1
    joyinp = axis(joy,1:5);
    %disp(joyinp)
    pause(0.01)
    thr = (1-joyinp(3))*statThrust;
    tvec = zeros(2,2);
    tvec(:,1) = joyinp(1);
    tvec(:,2) = -joyinp(1);
    tvec(1,:) = tvec(1,:) + joyinp(2);
    tvec(2,:) = tvec(2,:) - joyinp(2);
    tvec([1 4])= tvec([1 4]) +joyinp(4);
    tvec([2 3])= tvec([2 3]) - joyinp(4);
    thr4 = thr+tvec*thr*0.1;
    disp(int16(thr4))
end