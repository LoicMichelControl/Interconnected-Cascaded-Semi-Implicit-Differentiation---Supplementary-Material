    
    % Evaluate the Sum of Square of the Error
    
    function SSE_ = SSE_eval ( diff_error )
    
    SSE_ = 0;
    
    for kk = 1:length(diff_error)
    
        SSE_ = SSE_ + ( diff_error(kk) ).^2;
    
    end
    
    SSE_ = SSE_ / length (diff_error) ;
    
    end