function ls = LMSToMacBoynDG(LMS,T_cones,T_lum)
% ls = LMSToMacBoyn(LMS,[T_cones,T_lum])
%
% Compute MacLeod-Boynton chromaticity from
% cone coordinates.
%
% If T_cones and T_lum are not passed, we assume
% Smith-Pokorny sensitivities normalized to a
% peak of 1.  I T_cones and T_lum are passed,
% we compute the scalings of the L and M cones
% required to best predict lumiance and scale
% accordingly.
%
% 10/30/97  dhb  Wrote it.
% 7/9/02    dhb  T_cones_sp -> T_cones on line 20.  Thanks to Eiji Kimura.
% 22/01/2019 dg  Added code to normalise s output as per CIE 170-2:2015

% Scale LMS so that L+M = luminance
if (nargin == 1)
	LMS = diag([0.6373 0.3924 0.0260]')*LMS;
else
	factors = [T_cones(1:2,:)'\T_lum'; 1/max(T_cones(3,:)./T_lum)];
	LMS = diag(factors)*LMS;
end

% Compute ls coordinates from LMS
n = size(LMS,2);
ls = zeros(2,n);
denom = [1 1 0]*LMS;
ls = LMS([1 3],:) ./ ([1 1]'*denom);
