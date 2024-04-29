    
    %=================================================================
    %=================================================================
    
    % "An interconnected discrete time cascaded semi-implicit differentiation"
    
    % Code associated to the work submitted to the VSS'24 conference
    
    % (c) [2024]  Nantes Université - Centrale Nantes - LS2N UMR 6004, Nantes
    % (c) [2024]  Quartz EA 7393, ENSEA, Cergy-Pontoise
    % Loïc MICHEL, Malek GHANES, Yannick AOUSTIN and Jean-Pierre BARBOT
    % All rights reserved under MIT license.
    
    % This code runs all numerical examples given in the paper.
    % Simply execute 'RUN_VSS_results.m' and all cases are displayed
    % successively. In addition, the figures are saved in the sub-directory 'Results'
    % and the associated statistics w.r.t. the estimation errors
    % are saved in the 'Result_error_evaluation.txt' file.
    %
    % The following cases are simulated:
    %
    % + Case #1 - Cascade including correction terms and knowledge of 'u'
    % + Case #2 - Cascade including correction terms BUT without knowledge of 'u'
    % + Case #3 - Cascade without correction terms and without knowledge of 'u'
    % + Case #4 - Cascade including correction terms and knowledge of 'u' ->
    % Addition of noise (under theta = 0)
    % + Case #5 - Cascade including correction terms and knowledge of 'u' ->
    % Addition of noise (under theta = 0.1)
    % + Case #6 - Cascade including correction terms and knowledge of 'u' ->
    % Addition of noise (under theta = 0.4)
    % + Case #7 - Cascade including correction terms and knowledge of 'u' ->
    % Addition of noise (under theta = 0.5)
    
    %=================================================================
    %=================================================================
    
    clear all
    close all
    warning off
    clc
    
    
    %% SIMULATION SETTINGS
    
    TMax = 60; % Maximum simulation time
    Deltah = 1e-1;  % Time-step
    
    % SYSTEM INPUT
    u = 1; % input U : start with u = 1 and turns into u = -1 at t = 30 sec.
    P = 0.5; % perturbation
    
    % SYSTEM INITIAL CONDITIONS
    
    xIC.x1_d = 0;
    xIC.x2_d = 0;
    xIC.x3_d = 0;
    
    % CASCADE PARAMETERS I.C.
    
    cascade_diff = 1; % Enable cascade differentiator
    
    c_alpha_1_1 = 0.95;  % alpha_1 first stage
    c_alpha_1_2 = 0.98;  % alpha_2 first stage
    
    c_lambda_1_1 = 2e2;  % lambda_1 first stage
    c_lambda_2_1 = 4e4;  % lambda_2 first stage
    
    c_lambda_1_2 = 2e2;  % lambda_1 sec. stage
    c_lambda_2_2 = 4e4;  % lambda_2 sec. stage
    
    c_theta_1 = 0; % theta_1 proj. first stage
    c_theta_2 = 0; % theta_2 proj. first stage
    c_theta_3 = 0; % theta_1 proj. sec. stage
    c_theta_4 = 0; % theta_2 proj. sec. stage
    
    ForceThetaZero = 1; % theta parameters set to zero for the simulations without noise
    
    c_correction_factor = 1; % Enable the correction terms (enable = 1)
    
    PresetInputKnowledge = 1; % Preset the knowledge of u (= 1 if 'u' is included)
    
    NoiseAmp = 0; % Noise amplitude
    
    c_lambda_fwd = 0.3; % time-constant for the interconnection fwd
    
    c_MU_ = 1; % Set to 1 // not considered
    
    % MONO PARAMETERS I.C. (to be studied in a future version - sety but not used )
    
    mono_diff = 0; % Enable mono differentiator
    
    m_correction_factor = 1; % Set the correction terms (enable = 1)
    
    m_alpha_1 = 0.95;
    m_alpha_2 = 0.95;
    m_alpha_3 = 0.95;
    m_alpha_4 = 0.95;
    
    m_lambda_1 = 2e3;
    m_lambda_2 = 4e3;
    m_lambda_3 = 100*m_lambda_1;
    m_lambda_4 = 100*m_lambda_2;
    
    
    m_theta_1 = 0;
    m_theta_2 = 0;
    m_theta_3 = 0;
    m_theta_4 = 0;
    
    
    
    % --------------------------------------------------------------------
    caseNumber = 0; % Index of simulation cases

    if ( exist('Results', 'dir') == 0)
    mkdir Results/
    else
        cd ./Results/
        delete *.png
        cd ..
    end

    % --------------------------------------------------------------------
    % Case #1 - Cascade including correction terms and knowledge of 'u'
    
    name = "Case #1 : Cascade including correction terms and knowledge of 'u'";
    
    c_correction_factor = 1; % Enable the correction terms (enable = 1)
    
    PresetInputKnowledge = 1; % Preset the knowledge of u (= 1 if 'u' is included)
    
    NoiseAmp = 0; % Noise amplitude
    
    % Call of the implicit differentiator
    Call_ImplicitDifferentiator;
    
    pause(5)
    
    % --------------------------------------------------------------------
    % Case #2 - Cascade including correction terms BUT without knowledge of 'u'
    
    name = "Case #2 : Cascade including correction terms BUT without knowledge of 'u'";
    
    c_correction_factor = 1; % Enable the correction terms (enable = 1)
    
    PresetInputKnowledge = 0; % Preset the knowledge of u (= 1 if 'u' is included)
    
    NoiseAmp = 0; % Noise amplitude
    
    % Call of the implicit differentiator
    Call_ImplicitDifferentiator;
    
    pause(5)
    
    % --------------------------------------------------------------------
    % Case #3 - Cascade without correction terms and without knowledge of 'u'
    
    name = "Case #3 : Cascade without correction terms and without knowledge of 'u'";
    
    c_correction_factor = 0; % Enable the correction terms (enable = 1)
    
    PresetInputKnowledge = 0; % Preset the knowledge of u (= 1 if 'u' is included)
    
    NoiseAmp = 0; % Noise amplitude
    
    % Call of the implicit differentiator
    Call_ImplicitDifferentiator;
    
    pause(5)
    
    % --------------------------------------------------------------------
    % Case #4 - Cascade including correction terms and knowledge of 'u' ->
    % Addition of noise (under theta = 0)
    
    name = "Case #4 : Cascade including correction terms and knowledge of 'u' -> Addition of noise + zero theta";
    
    % Setting zero theta (again) ;)
    c_theta_1 = 0;
    c_theta_2 = 0;
    c_theta_3 = 0;
    c_theta_4 = 0;
    ForceThetaZero = 0;
    
    c_correction_factor = 1; % Enable the correction terms (enable = 1)
    
    PresetInputKnowledge = 1; % Preset the knowledge of u (= 1 if 'u' is included)
    
    % !!!!!!!!!! Addition of noise
    NoiseAmp = 1e-1; % Noise amplitude
    
    % Call of the implicit differentiator
    Call_ImplicitDifferentiator;
    
    pause(5)
    
    % --------------------------------------------------------------------
    % Case #5 - Cascade including correction terms and knowledge of 'u' ->
    % Addition of noise (under theta = 0.1)
    
    name = "Case #5 : Cascade including correction terms and knowledge of 'u' -> Addition of noise + 0.1 theta";
    
    % Setting 0.1 theta
    c_theta_1 = 0.1;
    c_theta_2 = 0.1;
    c_theta_3 = 0.1;
    c_theta_4 = 0.1;
    ForceThetaZero = 0;
    
    c_correction_factor = 1; % Enable the correction terms (enable = 1)
    
    PresetInputKnowledge = 1; % Preset the knowledge of u (= 1 if 'u' is included)
    
    % !!!!!!!!!! Addition of noise
    NoiseAmp = 1e-1; % Noise amplitude
    
    % Call of the implicit differentiator
    Call_ImplicitDifferentiator;
    
    pause(5)
    
    % --------------------------------------------------------------------
    % Case #6 - Cascade including correction terms and knowledge of 'u' ->
    % Addition of noise (under theta = 0.4)
    
    name = "Case #6 : Cascade including correction terms and knowledge of 'u' -> Addition of noise + 0.4 theta";
    
    % Setting 0.4 theta
    c_theta_1 = 0.4;
    c_theta_2 = 0.4;
    c_theta_3 = 0.4;
    c_theta_4 = 0.4;
    ForceThetaZero = 0;
    
    c_correction_factor = 1; % Enable the correction terms (enable = 1)
    
    PresetInputKnowledge = 1; % Preset the knowledge of u (= 1 if 'u' is included)
    
    % !!!!!!!!!! Addition of noise
    NoiseAmp = 1e-1; % Noise amplitude
    
    % Call of the implicit differentiator
    Call_ImplicitDifferentiator;
    
    pause(5)
    
    % --------------------------------------------------------------------
    % Case #7 - Cascade including correction terms and knowledge of 'u' ->
    % Addition of noise (under theta = 0.5)
    
    name = "Case #7 : Cascade including correction terms and knowledge of 'u' -> Addition of noise + 0.5 theta";
    
    % Setting 0.5 theta
    c_theta_1 = 0.5;
    c_theta_2 = 0.5;
    c_theta_3 = 0.5;
    c_theta_4 = 0.5;
    ForceThetaZero = 0;
    
    c_correction_factor = 1; % Enable the correction terms (enable = 1)
    
    PresetInputKnowledge = 0; % Preset the knowledge of u (= 1 if 'u' is included)
    
    % !!!!!!!!!! Addition of noise
    NoiseAmp = 1e-1; % Noise amplitude
    
    % Call of the implicit differentiator
    Call_ImplicitDifferentiator;
    
    
    % % % Case #mono-differentiator - To be investigated in a future version
    % % %--------------------------------------------------------------------
    % % % Case #mono - Test mono-differentiator (for future works ;) )
    % % 
    % % name = "Case #mono : Test mono-differentiator";
    % % 
    % % mono_diff = 1; % Enable mono differentiator
    % % cascade_diff = 0; % Disable cascade differentiator
    % % 
    % % m_correction_factor = 1; % Enable the correction terms (enable = 1)
    % % 
    % % PresetInputKnowledge = 1; % Preset the knowledge of u (= 1 if 'u' is included)
    % % 
    % % NoiseAmp = 0; % Noise amplitude
    % % 
    % % %Call of the implicit differentiator
    % % Call_ImplicitDifferentiator;
    
    close all
    
    fprintf("End of the program ! \n\n\n");
    
    %%=========================================================
    %%=========================================================
    %%=========================================================

