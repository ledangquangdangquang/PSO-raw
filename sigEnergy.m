function y = sigEnergy(x, tau)
%Calculates the energy of the sampled signal in x

if(nargin == 1)
  y = sum(abs(x).^2) ;
elseif(nargin == 2)
  y = sum(abs(x).^2) * mean(diff(tau));
end

