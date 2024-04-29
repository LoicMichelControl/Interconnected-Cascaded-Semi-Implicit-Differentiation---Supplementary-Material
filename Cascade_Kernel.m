    %=================================================================
    %=================================================================
    
    % Code associated to the work submitted to the VSS'24 conference
    
    % (c) [2024]  Nantes Université - Centrale Nantes - LS2N UMR 6004, Nantes
    % (c) [2024]  Quartz EA 7393, ENSEA, Cergy-Pontoise
    % Loïc MICHEL, Malek GHANES, Yannick AOUSTIN and Jean-Pierre BARBOT
    % All rights reserved under MIT license.
    
    %=================================================================
    %=================================================================
    
    % --------------- CASCADE DIFFERENTIATOR
    
    % System I.C.
    x1_d = xIC.x1_d;
    x2_d = xIC.x2_d;
    x3_d = xIC.x3_d;
    
    bcz2_fwd = 0; % correction term initialization
    
    uu = 0; % counter of the loop
    time = 0; % time
    while time <= TMax
    
        % Switching of the input 'u' from |u| to -|u| @t = 30 sec
        if ( time <= 30 )
            input_u = u;
        else
            input_u = -u;
        end
    
        uu = uu + 1;
        time_vec(uu) = Deltah * uu;
        time = Deltah * uu;
    
        input_u_vec(uu) = input_u;
    
        % Update the system states
        x3_p = input_u + P;
        x2_p = x2_d + Deltah * x3_p;
        x1_p = x1_d + Deltah * x2_p - Deltah^2/2 * x3_p;
    
        x1_d = x1_p;
        x2_d = x2_p;
        x3_d = x3_p;
    
        % Add noise to the output y_meas = x_1d
        y_meas = x1_d + eta_noise(uu);
    
        % ======== Differentiation section ========
    
        ce_1_vec(uu) = y_meas - cz1_d;
        ce_2_vec(uu) = x2_d - bcz1_d;
    
        % First Differentiator stage
        ce_1 = y_meas - cz1_d;
    
        [ cE_1, cProj_1 , borne_1 ] = Proj_function( c_alpha_1_1, c_lambda_p1_1, 1, ce_1, c_MU_, Deltah);
        [ cE_2, cProj_2 , borne_2 ] = Proj_function( c_alpha_1_1, c_lambda_p2_1, 2, ce_1, c_MU_, Deltah);
    
        cz2_p = cz2_d + cE_1 * Deltah *  ( c_lambda_2_1 * ( abs( ce_1 ) )^(2 * c_alpha_1_1 - 1 ) * cProj_2 + c_correction_factor * cE_2 * (( bcz2_fwd + PresetInputKnowledge * input_u  )) );
        cz1_p = cz1_d + Deltah * ( cz2_p + c_lambda_1_1 * ( abs( ce_1 ) )^c_alpha_1_1 * cProj_1 ) - c_correction_factor * cE_2 * (Deltah^2/2 * ((bcz2_fwd + PresetInputKnowledge * input_u )) );
    
        % Sec. Differentiator stage
        bce_1 = cz2_d - bcz1_d;
    
        [ cbE_1_, cProj_1_, borne_1b ] = Proj_function( c_alpha_1_2, c_lambda_p1_2, 1, bce_1, c_MU_, Deltah);
        [ cbE_2_, cProj_2_, borne_2b ] = Proj_function( c_alpha_1_2, c_lambda_p2_2, 2, bce_1, c_MU_, Deltah);
    
        bcz2_p = bcz2_d + cbE_1_ *  Deltah * ( c_lambda_2_2 * ( abs( bce_1 ) )^(2 * c_alpha_1_2 - 1 ) * cProj_2_ );
        bcz1_p = bcz1_d + Deltah * ( (( bcz2_p + PresetInputKnowledge * input_u )) + c_lambda_1_2 * ( abs( bce_1 ) )^c_alpha_1_2 * cProj_1_  ) ;
    
        bcz2_fwd =  bcz2_fwd + c_lambda_fwd * ( bcz2_p - bcz2_fwd ); % Interconnected / correction term
    
        % updates
        cz1_d = cz1_p;
        cz2_d = cz2_p;
    
        bcz1_d = bcz1_p;
        bcz2_d = bcz2_p;
    
        ce_3_vec(uu) = x3_d - bcz2_d - PresetInputKnowledge * input_u_vec(uu);
    
        x1_d_vec(uu) = x1_d;
        x2_d_vec(uu) = x2_d;
        x3_d_vec(uu) = x3_d;
    
        cz1_d_vec(uu) = cz1_d;
        cz2_d_vec(uu) = cz2_d;
        cz3_d_vec(uu) = bcz2_d;
    
        % === End of the Differentiation section ===
    
    end
    
    if (display_error == 1 && sweep_h == 0)
    
        cd ./Results
    
        fileName_error_png = sprintf("cascade_diff_case_%d_error.png", caseNumber);
    
        figure('units','normalized','outerposition',[0 0 1 1])
        pos1 = get(gcf,'Position');
        subplot(311)
        hold on
        plot( time_vec(1:end), ce_1_vec(1:end), 'b', 'linewidth', 3)
        grid on
        xlim([0,60]);
        ylabel('$e_1 \quad $','FontSize',50, 'Interpreter','latex')
        grid on
        set(gca,'FontSize',50)
        subplot(312)
        hold on
        plot( time_vec(1:end), ce_2_vec(1:end), 'b', 'linewidth', 3)
        grid on
        xlim([0,60]);
        ylabel('$e_2 \quad $','FontSize',50, 'Interpreter','latex')
        set(gcf,'Color','w');
        set(gca,'FontSize',50);
        subplot(313)
        hold on
        plot( time_vec(1:end), ce_3_vec(1:end), 'b', 'linewidth', 3)
        grid on
        xlim([0,60]);
        xlabel('Time [s]', 'FontSize',50, 'Interpreter', 'LaTex', 'FontSize',50);
        ylabel('$e_3 \quad $','FontSize',50, 'Interpreter','latex')
        set(gcf,'Color','w');
        set(gca,'FontSize',50);
        set(gcf,'Position', pos1 - [pos1(3)/2,0,0,0])
        saveas(gcf,fileName_error_png)
    
        fileName_est_states_png = sprintf("cascade_diff_case_%d_est_states.png", caseNumber);
    
        figure('units','normalized','outerposition',[0 0 1 1])
        set(gcf,'Position', get(gcf,'Position') + [0,0,0,0])
        pos2 = get(gcf,'Position');
        subplot(211)
        hold on
        plot( time_vec, x1_d_vec, 'b', 'linewidth', 3);
        plot( time_vec, cz1_d_vec, '--m', 'linewidth', 3);
        xlim([0,60]);
        legend('$x_1$','$z_1$', 'FontSize',50, 'Interpreter','latex')
        set(gcf,'Color','w');
        set(gca,'FontSize',50);
        subplot(212)
        hold on
        plot( time_vec, x2_d_vec, 'k', 'linewidth', 3);
        plot( time_vec, cz2_d_vec, '--r', 'linewidth', 3);
        xlim([0,60]);
        xlabel('Time [s]', 'FontSize',50, 'Interpreter', 'LaTex');
        legend('$x_2$','$z_2$', 'FontSize',50, 'Interpreter','latex')
        set(gcf,'Color','w');
        set(gca,'FontSize',50);
        set(gcf,'Position', pos2 + [pos1(3)/2,0,0,0])
        saveas(gcf,fileName_est_states_png)
    
        cd ..
    
    end

