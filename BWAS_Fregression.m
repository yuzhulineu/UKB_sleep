function [fstats,p]=BWAS_Fregression(y,X,cov)
%        [fstats,p]=BWAS_Fregression(y,X,cov)
%        Do not include a colum of one in X or cov
% Input:
%    y: m-by-n, m feature and n samples (y is a continue variable)
%    X: n-by-p, A set of variable of interests.
%    cov: n-by-p1, The covariates.
%The function test the co-effect of X on y conditioned on cov.
% Output:
%    Fstat: A vector of F-statistic one for each row of dat.
%        p: p-value.
%

n=size(y,2);
tmp=ones(n,1);
if nargin<3 || isempty(cov)
    mod=[X,tmp];
    mod0=tmp;
else
    mod=[X,cov,tmp];
    mod0=[cov,tmp];
end

df1=size(mod,2);
df0=size(mod0,2);
Id=eye(n);

resid = y * (Id - mod*(inv(mod'*mod)*mod'));
rss1 = sum(resid.*resid,2);
clear resid

resid0 = y * (Id - mod0*(inv(mod0'*mod0)*mod0'));
rss0 = sum(resid0.*resid0,2);
clear resid0

fstats = ((rss0 - rss1)/(df1-df0))./(rss1/(n-df1));

p=fcdf(fstats,df1-df0,n-df1,'upper');


end