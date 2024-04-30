    
    %=================================================================
    %=================================================================
    
    % Code associated to the work submitted to the VSS'24 conference
    
    % (c) [2024]  Nantes Université - Centrale Nantes - LS2N UMR 6004, Nantes
    % (c) [2024]  Quartz EA 7393, ENSEA, Cergy-Pontoise
    % Loïc MICHEL, Malek GHANES, Yannick AOUSTIN and Jean-Pierre BARBOT
    % All rights reserved under MIT license.
    
    %=================================================================
    %=================================================================
    
    function ImplicitDifferentiator ( TMax , ...
        Deltah , ...
        NoiseAmp , ...
        PresetInputKnowledge , ...
        ForceThetaZero, ...
        cascade_diff, ...
        mono_diff , ...
        u , ...
        P , ...
        c_alpha_1_1 , ...
        c_alpha_1_2 , ...
        c_lambda_1_1 , ...
        c_lambda_2_1 , ...
        c_lambda_1_2 , ...
        c_lambda_2_2 , ...
        c_theta_1 , ...
        c_theta_2 , ...
        c_theta_3 , ...
        c_theta_4 , ...
        c_lambda_fwd , ...
        m_alpha_1 , ...
        m_alpha_2 , ...
        m_alpha_3 , ...
        m_alpha_4 , ...
        m_lambda_1, ...
        m_lambda_2 , ...
        m_lambda_3 , ...
        m_lambda_4 , ...
        m_theta_1 , ...
        m_theta_2 , ...
        m_theta_3 , ...
        m_theta_4 , ...
        xIC , ...
        m_correction_factor , ...
        MU_ , ...
        c_correction_factor, ...
        name, ...
        caseNumber)
    
    fprintf('======================================================================================== \n\n');
    
    fprintf(' "An interconnected discrete time cascaded semi-implicit differentiation" \n')
    
    fprintf('Code associated to the work submitted to the VSS''24 conference \n\n')
    
    fprintf('** Loïc MICHEL, Malek GHANES, Yannick AOUSTIN and Jean-Pierre BARBOT ** \n\n')
    
    fprintf(['Copyright (c) 2024 - Nantes Université - Centrale Nantes - LS2N UMR 6004 \n' ...
        'Copyright (c) 2024 - Quartz EA 7393, ENSEA, Cergy-Pontoise \n'] )
    
    fprintf('======================================================================================== \n\n');
    
    % Noise vector creation
    eta_noise = NoiseAmp * rand( 1, length( 0:Deltah:TMax ) );
    
    fprintf('Starting: ')
    
    if ( cascade_diff == 1)
        fprintf('Cascade processing ... \n')
    
        if ( PresetInputKnowledge == 1)
            fprintf(' Warning: Preset of ''u'' enabled ! \n')
        else
            fprintf(' Warning: Preset of ''u'' disabled ! \n')
        end
    
    
        if ( c_correction_factor == 1  )
            fprintf(' Warning: Correction terms enabled ! \n')
        else
            fprintf(' Warning: Correction terms disabled ! \n')
        end
    
    end
    
    if ( ForceThetaZero == 1)
        fprintf(' Warning: theta parameters are set to zero ! \n')
    end
    
    if ( mono_diff == 1)
        fprintf('Mono processing ... ')
    end
    
    pause(5)
    
    display_error = 1; % internal -> should ne be changed
    
    % ======================================================
    % CASCADE-DIFFERENTIATOR
    % ======================================================
    
    if ( ForceThetaZero == 1 )
    
        c_theta_1 = 0;
        c_theta_2 = 0;
        c_theta_3 = 0;
        c_theta_4 = 0;
    
    end
    
    if ( cascade_diff == 1)
    
        % Defines (lambda & alpha) as Xc parameters, and (theta) as Tc parameters
        Xc0(1) = c_lambda_1_1;
        Xc0(2) = c_lambda_2_1;
        Xc0(3) = c_lambda_1_2;
        Xc0(4) = c_lambda_2_2;
    
        Xc0(5) = c_alpha_1_1;
        Xc0(6) = c_alpha_1_2;
    
        Xc0(7) = MU_;
    
        Tc0(1) = c_theta_1;
        Tc0(2) = c_theta_2;
        Tc0(3) = c_theta_3;
        Tc0(4) = c_theta_4;
    
        error = Cascade_function ( Xc0, Tc0, TMax, u, P, Deltah, xIC, c_correction_factor, ...
            display_error, eta_noise, 0, PresetInputKnowledge, c_lambda_fwd, caseNumber);
    
        % Print the results in a txt file
    
        % Latex friendly
        fid = fopen('Result_error_evaluation_latex.txt', 'a');
        fprintf(fid,'%d %1.20f & %1.20f & %1.20f & %1.20f & %1.20f & %1.20f & %1.20f & %1.20f & %1.20f \n', caseNumber, error(1,1), error(1,2), error(1,3), error(2,1), error(2,2), error(2,3), error(3,1), error(3,2), error(3,3));
        fclose all;
    
        % standard: prints the AVG, MAX and SSE statistics
        fid = fopen('Result_error_evaluation.txt', 'a');
        fprintf(fid, '\n ******* %s \n\n', name);
        fprintf(fid, ['[ avg(e_1)_(last 1/4) = %1.2e, max(|e_1|) = %1.3f, SSE(e_1)_(last 1/4) = %1.2e] \n' ...
            '[ avg(e_2)_(last 1/4) = %1.2e, max(|e_2|) = %1.3f, SSE(e_2)_(last 1/4) = %1.2e] \n' ...
            '[ avg(e_3)_(last 1/4) = %1.2e, max(|e_3|) = %1.3f, SSE(e_3)_(last 1/4) = %1.2e] \n\n'], ...
            error(1,1), error(1,2), error(1,3), ...
            error(2,1), error(2,2), error(2,3), ...
            error(3,1), error(3,2), error(3,3));
        fclose all;
    
    end
    
    % ======================================================
    % MONO-DIFFERENTIATOR
    % ======================================================
    
    if ( mono_diff == 1)
    
        % Defines (lambda & alpha & theta) as Xm parameters
        Xm0(1) = m_lambda_1;
        Xm0(2) = m_lambda_2;
        Xm0(3) = m_lambda_3;
        Xm0(4) = m_lambda_4;
    
        Xm0(5) = m_alpha_1;
        Xm0(6) = m_alpha_2;
        Xm0(7) = m_alpha_3;
        Xm0(8) = m_alpha_4;
    
        Xm0(9) = m_theta_1;
        Xm0(10) = m_theta_2;
        Xm0(11) = m_theta_3;
        Xm0(12) = m_theta_4;
    
        m_MU_ = 1;
    
        error = Mono_function ( Xm0, TMax, u, P, Deltah, xIC, m_correction_factor, ...
            display_error, eta_noise, 0, PresetInputKnowledge, caseNumber);
    
        % Print the results in a txt file
        fprintf('\n *****************************************');
        fprintf(['\n\n [ avg(e_1)_(last 1/4) = %1.2e, max( |e_1|) = %1.3f ] \n' ...
            '[ avg(e_2)_(last 1/4) = %1.2e, max( |e_2|) = %1.3f ] \n' ...
            '[ avg(e_3)_(last 1/4) = %1.2e, max( |e_3|) = %1.3f ] \n\n'], ...
            error(1,1), error(1,2), ...
            error(2,1), error(2,2), ...
            error(3,1), error(3,2));
    
    end
    
    %  fprintf('End ! \n')
    
    end
    
    %%=============================================
    %%=============================================
    
    
    
    

