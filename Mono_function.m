    
    %=================================================================
    %=================================================================
    
    % Code associated to the work submitted to the VSS'24 conference
    
    % (c) [2024]  Nantes Université - Centrale Nantes - LS2N UMR 6004, Nantes
    % (c) [2024]  Quartz EA 7393, ENSEA, Cergy-Pontoise
    % Loïc MICHEL, Malek GHANES, Yannick AOUSTIN and Jean-Pierre BARBOT
    % All rights reserved under MIT license.
    
    %=================================================================
    %=================================================================
    
    function exit = Mono_function ( X , ...
        TMax, ...
        u, ...
        P, ...
        Deltah, ...
        xIC, ...
        m_correction_factor, ...
        display_error, ...
        eta_noise, ...
        sweep_h, ...
        PresetInputKnowledge, ...
        caseNumber)
    
    % system IC
    x1_d = xIC.x1_d;
    x2_d = xIC.x2_d;
    x3_d = xIC.x3_d;
    
    % diff. IC
    mz1_d = 0;
    mz2_d = 0;
    mz3_d = 0;
    mz4_d = 0;
    
    % assign (lambda, alpha, theta) parameters
    m_lambda_1 = X(1);
    m_lambda_2 = X(2);
    m_lambda_3 = X(3);
    m_lambda_4 = X(4);
    
    m_alpha_1 = X(5);
    m_alpha_2 = X(6);
    m_alpha_3 = X(7);
    m_alpha_4 = X(8);
    
    m_theta_1 = X(9);
    m_theta_2 = X(10);
    m_theta_3 = X(11);
    m_theta_4 = X(12);
    
    m_MU_ = 1;
    
    m_lambda_p1 = abs(m_lambda_1 / (1 - m_theta_1));
    m_lambda_p2 = abs(m_lambda_2 / (1 - m_theta_2));
    m_lambda_p3 = abs(m_lambda_3 / (1 - m_theta_3));
    m_lambda_p4 = abs(m_lambda_4 / (1 - m_theta_4));
    
    if ( display_error == 1 && sweep_h == 0)
    
        fprintf('\n --- RUNNING MONO DIFFERENTIATOR --- \n');
    
        fprintf('\n lambda_1 = %f \n lambda_2 = %f \n lambda_3 = %f \n lambda_4 = %f \n', m_lambda_1, m_lambda_2, m_lambda_3, m_lambda_4 );
    
        fprintf('\n theta_1 = %f \n theta_2 = %f \n theta_3 = %f \n theta_4 = %f \n', m_theta_1, m_theta_2, m_theta_3, m_theta_4 );
    
        fprintf('\n |u| = %f and P = %f \n', abs(u), P);
    end
    
    % Evaluate the monolithic differentiator
    Mono_Kernel;
    
    le_ = floor(length( me_1_vec )/2) + floor(length( me_1_vec )/4);
    
    % Error stat.
    exit = [ mean(me_1_vec(le_:end)), max( abs(me_1_vec(1:end)) ); ...
        mean(me_2_vec(le_:end)), max( abs(me_2_vec(1:end)) ); ...
        mean(me_3_vec(le_:end)), max( abs(me_3_vec(1:end)) ) ];
    
    end