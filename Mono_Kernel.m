    
    %=================================================================
    %=================================================================
    
    % Code associated to the work submitted to the VSS'24 conference
    
    % (c) [2024]  Nantes Université - Centrale Nantes - LS2N UMR 6004, Nantes
    % (c) [2024]  Quartz EA 7393, ENSEA, Cergy-Pontoise
    % Loïc MICHEL, Malek GHANES, Yannick AOUSTIN and Jean-Pierre BARBOT
    % All rights reserved under MIT license.
    
    %=================================================================
    %=================================================================
    
    % --------------- MONOLITHIC DIFFERENTIATOR
    
    % System I.C.
    x1_d = xIC.x1_d;
    x2_d = xIC.x2_d;
    x3_d = xIC.x3_d;
    
    uu = 0; % counter of the loop
    time = 0; % time
    while time <= TMax
    
        uu = uu + 1;
    
        time_vec(uu) = Deltah * uu;
    
        time = Deltah * uu;
    
        % Switching of the input 'u' from |u| to -|u| @t = 30 sec
        if ( time <= 30 )
            input_u = u;
        else
            input_u = -u;
        end
    
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
    
        me_1_vec(uu) = y_meas - mz1_d;
        me_2_vec(uu) = x2_d - mz2_d;
        me_3_vec(uu) = x3_d - mz3_d - PresetInputKnowledge * input_u_vec(uu);
    
        me_1 = y_meas - mz1_d;
    
        [ mE_1, mProj_1_ ] = Proj_function( m_alpha_1, m_lambda_p1, 1, me_1, m_MU_, Deltah);
    
        [ mE_2, mProj_2_ ] = Proj_function( m_alpha_2, m_lambda_p2, 2, me_1, m_MU_, Deltah);
    
        [ mE_3, mProj_3_ ] = Proj_function( m_alpha_3, m_lambda_p3, 3, me_1, m_MU_, Deltah);
    
        [ mE_4, mProj_4_ ] = Proj_function( m_alpha_4, m_lambda_p4, 4, me_1, m_MU_, Deltah);
    
        mz4_p = mz4_d + ((((( 0 ))))) *(Deltah * mE_1 * mE_2 * mE_3 * m_lambda_4 * ( ( m_MU_  )^4 ) * ( abs(  me_1 ) )^(4 * m_alpha_4 - 3 ) * mProj_4_ );
    
        mz3_p = mz3_d + (Deltah * mE_1 * mE_2 * ( mz4_p + m_lambda_3 * ( ( m_MU_  )^3 ) * ( abs(  me_1 ) )^(3 * m_alpha_3 - 2 ) * mProj_3_ ) );
    
        %    (((( mz3_p = 0; ))))
    
        mz2_p = mz2_d + Deltah * mE_1 * ( (( mz3_p + PresetInputKnowledge * input_u )) - ((m_correction_factor * 1/2  * Deltah * mz4_p )) + m_lambda_2 * mE_1 * ( ( m_MU_  )^2 ) * ( abs(  me_1 ) )^(2 * m_alpha_2 - 1 ) * mProj_2_ );
    
        mz1_p = mz1_d + Deltah * ( mz2_p - ((m_correction_factor * 1/2  * Deltah * (( mz3_p + PresetInputKnowledge * input_u ))   )) + ((m_correction_factor * 1/6 * Deltah^2 * mz4_p )) + m_lambda_1 * ( ( m_MU_  ) ) * ( abs( me_1 ) )^m_alpha_1 * mProj_1_  );
    
        % updates
        mz1_d = mz1_p;
        mz2_d = mz2_p;
        mz3_d = mz3_p;
        mz4_d = 0; % mz4_p;
    
        mz1_d_vec(uu) = mz1_d;
        mz2_d_vec(uu) = mz2_d;
        mz3_d_vec(uu) = mz3_d;
        mz4_d_vec(uu) = mz4_d;

        % === End of the Differentiation section ===
    
    end
    
    if (display_error == 1 && sweep_h == 0)
    
        figure('name','Mono differentiation')
        subplot(311)
        plot( time_vec(1:end), me_1_vec(1:end), 'b', 'linewidth', 2)
        grid on
        ylabel('$e_1 \quad $','Interpreter','latex')
        grid on
        set(gca,'FontSize',20)
        subplot(312)
        plot( time_vec(1:end), me_2_vec(1:end), 'b', 'linewidth', 2)
        grid on
        ylabel('$e_2 \quad $','Interpreter','latex')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
        subplot(313)
        plot( time_vec(1:end), me_3_vec(1:end), 'b', 'linewidth', 2)
        grid on
        ylabel('$e_3 \quad $','Interpreter','latex')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
    
    end
