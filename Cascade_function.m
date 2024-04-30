    
    %=================================================================
    %=================================================================
    
    % Code associated to the work submitted to the VSS'24 conference
    
    % (c) [2024]  Nantes Université - Centrale Nantes - LS2N UMR 6004, Nantes
    % (c) [2024]  Quartz EA 7393, ENSEA, Cergy-Pontoise
    % Loïc MICHEL, Malek GHANES, Yannick AOUSTIN and Jean-Pierre BARBOT
    % All rights reserved under MIT license.
    
    %=================================================================
    %=================================================================
    
    
    function exit = Cascade_function ( X, ...
        T, ...
        TMax, ...
        u, ...
        P, ...
        Deltah, ...
        xIC, ...
        c_correction_factor, ...
        display_error, ...
        eta_noise, ...
        sweep_h, ...
        PresetInputKnowledge, ...
        c_lambda_fwd, ...
        caseNumber)
    
    % diff. IC
    cz1_d = -0.7;
    cz2_d = -1;
    
    bcz1_d = 0.5;
    bcz2_d = 1;
    
    bcz1_p = 0;
    bcz2_p = 0;
    
    % system IC
    x1_d = xIC.x1_d;
    x2_d = xIC.x2_d;
    x3_d = xIC.x3_d;
    
    % assign (lambda, alpha, theta) parameters
    
    % Defines (lambda & alpha) from X parameters, and (theta) from T parameters
    c_lambda_1_1 = X(1);
    c_lambda_2_1 = X(2);
    c_lambda_1_2 = X(3);
    c_lambda_2_2 = X(4);
    
    c_alpha_1_1 = X(5);
    c_alpha_1_2 = X(6);
    c_MU_ = X(7);
    
    c_theta_1_1 = T(1);
    c_theta_1_2 = T(2);
    c_theta_2_1 = T(3);
    c_theta_2_2 = T(4);
    
    
    
    c_lambda_p1_1 = abs(c_lambda_1_1 / (1 - c_theta_1_1));
    c_lambda_p2_1 = abs(c_lambda_2_1 / (1 - c_theta_1_2));
    c_lambda_p1_2 = abs(c_lambda_1_2 / (1 - c_theta_2_1));
    c_lambda_p2_2 = abs(c_lambda_2_2 / (1 - c_theta_2_2));
    
    if ( display_error == 1 && sweep_h == 0)
    
        fprintf('--- RUNNING CASCADE DIFFERENTIATOR --- \n');
    
        fprintf('\n lambda_1_1 = %f \n lambda_2_1 = %f \n lambda_1_2 = %f \n lambda_2_2 = %f \n lambda_fwd = %f \n', c_lambda_1_1, c_lambda_1_2, c_lambda_2_1, c_lambda_2_2, c_lambda_fwd );
    
        fprintf('\n alpha_1 = %f \n alpha_2 = %f \n', c_alpha_1_1, c_alpha_1_2);
    
        fprintf('\n theta_1 = %f \n theta_2 = %f \n theta_3 = %f \n theta_4 = %f \n', c_theta_1_1, c_theta_1_2, c_theta_2_1, c_theta_2_2 );
    
        fprintf('\n |u| = %f and P = %f \n', abs(u), P);
    end
    
    % Evaluate the cascade differentiator
    Cascade_Kernel;
    
    le_ = floor( length( ce_1_vec )/2 ) + floor( length( ce_1_vec )/4 );
    
    % Error statistics (AVG, MAX and SSE)
    exit = [ mean(ce_1_vec(le_:end)), max( abs(ce_1_vec(1:end)) ), SSE_eval(ce_1_vec(le_:end)); ...
             mean(ce_2_vec(le_:end)), max( abs(ce_2_vec(1:end)) ), SSE_eval(ce_2_vec(le_:end)); ...
             mean(ce_3_vec(le_:end)), max( abs(ce_3_vec(1:end)) ), SSE_eval(ce_3_vec(le_:end)) ];
    
    
    
    end