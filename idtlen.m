function id = idtlen(X,dists,epsilon)
%% TLE estimator: excluding central measurements, excluding reflections
% X - matrix of nearest neighbors (k x d), sorted by distance
% dists - nearest-neighbor distances (1 x k), sorted
% epsilon - threshold for dropping measurements in order to avoid numerical issues
    if nargin < 2
        error('Two parameters required: X - matrix of nearest neighbors (k x d), sorted by distance; dists - nearest-neighbor distances (1 x k), sorted');
    end
    if nargin == 2
        % if epsilon is too large, too many measurements can be dropped, yielding NaN or very large IDs
        % if epsilon is too small, numerical issues can produce imaginary values
        epsilon = 0.00001; % default value expected to work in the vast majority of cases
    end
    r = dists(end); % distance to k-th neighbor
    %% Boundary case 1: If r = 0, this is fatal, since the neighborhood would be degenerate
    if r == 0
        error('All k-NN distances are zero!');
    end
    %% Main computation
    k = length(dists);
    V = squareform(pdist(X));
    Di = repmat(dists',1,k);
    Dj = Di';
    S = r * (((Di.^2 + V.^2 - Dj.^2).^2 + 4*V.^2 .* (r^2 - Di.^2)).^0.5 - (Di.^2 + V.^2 - Dj.^2)) ./ (2*(r^2 - Di.^2));
    Dr = dists == r; % handle case of repeating k-NN distances
    S(Dr,:) = r * V(Dr,:).^2 ./ (r^2 + V(Dr,:).^2 - Dj(Dr,:).^2);
    %% Boundary case 2: If u_i = 0, then for all 1 <= j <= k the measurements s_ij reduce to u_j
    Di0 = Di == 0; 
    S(Di0) = Dj(Di0);
    %% Boundary case 3: If u_j = 0, then for all 1 <= j <= k the measurements s_ij reduce to (r v_ij)/(r + v_ij)
    Dj0 = Dj == 0; 
    S(Dj0) = r * V(Dj0) ./ (r + V(Dj0));
    %% Boundary case 4: If v_ij = 0, then the measurement s_ij is zero and must be dropped
    V0 = V == 0;
    V0(logical(eye(k))) = 0;
    S(V0) = r; % by setting to r, s_ij will not contribute to the sum s1s
    nV0 = sum(V0(:)); % will subtract this number during ID computation below
    %% Drop S measurements below epsilon
    Seps = S < epsilon | isnan(S); % also drop NaN measurements, "legitemately" obtained as 0/0
    Seps(logical(eye(k))) = 0;
    nSeps = sum(Seps(:));
    S(Seps) = r;
    S = log(S/r);
    S(logical(eye(k))) = 0; % delete diagonal elements
    %% Sum over the whole matrix
    s1s = sum(S(:));
    %% Compute ID, subtracting numbers of dropped measurements
    if s1s > -epsilon % Boundary case 5: (almost) all kNN distances are equal
        id = 0;
    else
        id = -(k*(k-1)-nSeps-nV0) / s1s;
    end
end
