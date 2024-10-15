function result = factorial_function(n)
    % This function calculates the factorial of a non-negative integer n.
    if n < 0
        error('Input must be a non-negative integer');
    elseif n == 0 || n == 1
        result = 1;
    else
        result = n * factorial_function(n - 1);
    end
end
