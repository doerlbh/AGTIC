function ints = randint(ub, N)
    % Returns N random integers drawn from [0, ub)
    assert(ub == floor(ub));
    assert(ub > 0);
    
    x = rand(N,1);
    ints = floor(x*ub);
end