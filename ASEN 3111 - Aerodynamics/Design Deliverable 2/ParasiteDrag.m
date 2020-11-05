function Cd0 = ParasiteDrag(c, x_cr, rho_inf, V_inf, mu_inf, Re_x_cr)
%ParasiteDrag computes the skin friction drag coefficient based on
%atmospheric conditions, chord length, and transition point
tp = Tempest_Parameters();
q_inf = (1/2)*rho_inf*V_inf^2;
Re_c = (rho_inf*V_inf*c) ./ mu_inf;

if (x_cr./c < 1)
    %occurs when x_cr is within the length of the chord
    Cf_c_turb = (0.074 ./ (Re_c.^(1/5)));
    Cf_1_turb = 0.074 / (Re_x_cr^(1/5));
    Cf_1_lam = 1.328 / sqrt(Re_x_cr);
    
    Df_2_turb = q_inf*c.*Cf_c_turb - q_inf*x_cr*Cf_1_turb;
    Df_1_lam = q_inf*x_cr*Cf_1_lam;
    
    Df = 4*(Df_1_lam + Df_2_turb);
    Cd0 = mean(Df / (q_inf*tp.S));
else
    %only occurs for fully laminar flow
    Cf_c_lam = 1.328 ./ sqrt(Re_c);
    Df_c_lam = q_inf*c.*Cf_c_lam;
    Df = 4*(Df_c_lam);
    Cd0 = mean(Df / (q_inf*tp.S));
end

end

