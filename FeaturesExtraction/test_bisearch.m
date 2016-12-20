function mnf = test_bisearch(p)
    low = 1;
    high = length(p);
    mid = ceil((low+high)/2);
    N = length(p);
    while ~( sum(p(1:mid)) >= sum(p((mid+1):N)) && sum(p(1:(mid-1))) < sum(p(mid:N)) )
	    if sum(p(1:mid)) < sum(p((mid+1):N))
	        low = mid;
	    else
	        high = mid;
        end
%         fixed the original bug here.
        if p(1) == max(p)
            mid = floor((low+high)/2);
        else
            mid = ceil((low+high)/2);
        end
	    
    end
    mnf = mid;