function kl = symm_kl_div(m1,m2)
% symmetric kullback leibler divergence between MVN m1.W and m2.W
if isfield(m1,'W') && ~isempty(m1.W.Mu_W)
    [nprec,ndim] = size(m1.W.Mu_W);
    kl = 0;  
    for n=1:ndim
        if size(m1.W.S_W,1)==size(m1.W.S_W,2) % full cov matrix
            i = (1:nprec) + (n-1)*nprec;
            kl = kl + 0.5 * gauss_kl(m1.W.Mu_W(:,n),m2.W.Mu_W(:,n),m1.W.S_W(i,i),m2.W.S_W(i,i)) + ...
                0.5 * gauss_kl(m2.W.Mu_W(:,n),m1.W.Mu_W(:,n),m2.W.S_W(i,i),m1.W.S_W(i,i));
        else
            kl = kl + 0.5 * gauss_kl(m1.W.Mu_W(:,n),m2.W.Mu_W(:,n),...
                squeeze(m1.W.S_W(n,:,:)),squeeze(m2.W.S_W(n,:,:))) + ...
                0.5 * gauss_kl(m2.W.Mu_W(:,n),m1.W.Mu_W(:,n),...
                squeeze(m2.W.S_W(n,:,:)),squeeze(m1.W.S_W(n,:,:)));
        end
    end
else
    ndim = size(m1.Omega.Gam_rate,2);
    if size(m1.Omega.Gam_rate,2) == size(m1.Omega.Gam_rate,1) % full
        kl = 0.5 * wishart_kl(m1.Omega.Gam_rate,m2.Omega.Gam_rate, ...
            m1.Omega.Gam_shape,m2.Omega.Gam_shape) + ...
            0.5 * wishart_kl(m2.Omega.Gam_rate,m1.Omega.Gam_rate, ...
            m2.Omega.Gam_shape,m1.Omega.Gam_shape);
    else
        kl = 0;
        for n=1:ndim
           kl = kl + 0.5 * gamma_kl(m1.Omega.Gam_shape,m2.Omega.Gam_shape,...
               m1.Omega.Gam_rate(n),m2.Omega.Gam_rate(n)) + ...
               0.5 * gamma_kl(m2.Omega.Gam_shape,m1.Omega.Gam_shape,...
               m2.Omega.Gam_rate(n),m1.Omega.Gam_rate(n));
        end
    end 
end
end