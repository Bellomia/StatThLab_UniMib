function [vx0, vy0, vz0] = speed_extraction

    global nat T0 mass

    vx0 = zeros(nat,1);
    vy0 = zeros(nat,1);
    vz0 = zeros(nat,1);

    cost = sqrt(3*T0/(11603*mass)); % 11603 = 1/Kb in [eV/K]

    for i=1:nat

        vx0(i) = cost*(2*rand - 1);
        vy0(i) = cost*(2*rand - 1);
        vz0(i) = cost*(2*rand - 1);
    
    end
    
end