function [s, ds, dds] = generatePulse(md, tau_0, tau, normalize)
%==========================================================================
% generatePulse.m
%   Sinh xung RC hoặc RRC cho kênh truyền
%
% INPUT:
%   md.type = 'RC' hoặc 'RRC'
%   md.Tp   = symbol duration
%   md.beta = roll-off factor
%   tau_0   = offset
%   tau     = vector thời gian
%   normalize = cách chuẩn hóa (0,1,2,3)
%
% OUTPUT:
%   s   = pulse
%   ds  = đạo hàm bậc 1 (nếu cần)
%   dds = đạo hàm bậc 2 (nếu cần)
%==========================================================================

if ~(strcmp(md.type, 'RC') || strcmp(md.type, 'RRC'))
    error('Only RC and RRC pulse supported!');
end

tau = tau(:);
if length(tau) > 1
    tau_res = tau(2) - tau(1);
else
    tau_res = 0;
end

%% -------- RC pulse --------
if strcmp(md.type, 'RC')
    t = tau - tau_0;
    i = find(t==0);
    
    a = sin(pi*t/md.Tp);
    b = cos(pi*md.beta*t/md.Tp);
    c = pi*t/md.Tp;
    d = 1 - 4*md.beta^2*t.^2/md.Tp^2;
    
    s = a.*b ./ (c.*d);
    s(abs(abs(t)-0) < tau_res/1e3) = 1;
    s(abs(abs(t)-md.Tp/2/md.beta) < tau_res/1e3) = sinc(1/2/md.beta)*pi/4;
    
    if nargout > 1
        adot = pi/md.Tp*cos(pi*t/md.Tp);
        bdot = -pi*md.beta/md.Tp*sin(pi*md.beta*t/md.Tp);
        cdot = pi/md.Tp;
        ddot = -8*md.beta^2*t/md.Tp^2;
        ds = ((adot.*b+bdot.*a).*c.*d - a.*b.*(cdot.*d+ddot.*c)) ./ (c.*d).^2;
        ds(i) = 0;
    end
    
    if nargout > 2
        dds = zeros(size(t));
        idx = find(abs(t) < tau_res/1e3);
        for k = 1:length(idx)
            if idx(k) > 1 && idx(k) < length(t)
                dds(idx(k)) = (dds(idx(k)-1)+dds(idx(k)+1))/2;
            elseif idx(k)==1
                dds(idx(k)) = dds(2);
            else
                dds(idx(k)) = dds(end-1);
            end
        end
    end
    
%% -------- RRC pulse --------
elseif strcmp(md.type, 'RRC')
    t = tau - tau_0;
    i = find(t==0);
    
    a = 4*md.beta*cos(pi*(1+md.beta)*t/md.Tp);
    b = sin(pi*(1-md.beta)*t/md.Tp);
    c = md.Tp./t;
    d = 1 - 16*md.beta^2*t.^2/md.Tp^2;
    
    s = 1/(pi*sqrt(md.Tp)) * (a+b.*c)./d;
    s(i) = 1/sqrt(md.Tp)*(1 - md.beta + 4*md.beta/pi);
    s(abs(abs(t)-md.Tp/4/md.beta) < tau_res/1e3) = ...
        md.beta/sqrt(2*md.Tp)*((1+2/pi)*sin(pi/4/md.beta) + (1-2/pi)*cos(pi/4/md.beta));
    
    if nargout > 1
        ds = zeros(size(t));
        idx = abs(abs(t)-md.Tp/2) < tau_res/1e3;
        for k = 1:sum(idx)
            pos = find(idx,k);
            if pos>1 && pos<length(ds)
                ds(pos) = (ds(pos-1)+ds(pos+1))/2;
            elseif pos==1
                ds(pos) = ds(2);
            else
                ds(pos) = ds(end-1);
            end
        end
    end
    
    if nargout > 2
        dds = zeros(size(t)); % để tránh lỗi index
    end
end

%% ---- Chuẩn hóa ----
if nargin > 3
    if normalize == 0
        if strcmp(md.type,'RC')
            normFactor = sqrt(0.875*md.Tp);
        else
            normFactor = 1;
        end
    elseif normalize == 1
        normFactor = max(abs(s));
    elseif normalize == 2
        normFactor = sqrt(sum(abs(s).^2));
    elseif normalize == 3
        normFactor = sqrt(trapz(tau,abs(s).^2));
    end
    
    s = s./normFactor;
    if nargout>1, ds = ds./normFactor; end
    if nargout>2, dds = dds./normFactor; end
end

s = s.';
end
