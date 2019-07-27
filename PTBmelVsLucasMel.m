% Checking that the melanopsin fundamental provided by PTB really is the
% Lucas et al. one (http://dx.doi.org/10.1016/j.tins.2013.10.004)

% PTB contents.m says:
%   T_melanopsin        - Melanopsin fundamental as provided by Lucas at
%                       -   http://lucasgroup.lab.ls.manchester.ac.uk/research/measuringmelanopicilluminance/
%                       -   This is for human observers at the cornea, in energy units.  Normalized to peak
%                       -   of unity.

% but it's fiddled around a little bit (renormalised and resampled at least) 
% and so I just want to check

%%

clc, clear, close all

load T_melanopsin.mat

% copy pasted from Column F of the refernece sheet of mmc2.xls
T_lucas = [0.000010
0.000019
0.000035
0.000067
0.000130
0.000260
0.000526
0.000906
0.001565
0.002134
0.002895
0.003658
0.004580
0.005406
0.006315
0.007182
0.008076
0.008956
0.009812
0.010467
0.011013
0.011299
0.011406
0.011315
0.011017
0.010519
0.009842
0.008956
0.007980
0.006951
0.005923
0.004933
0.004011
0.003184
0.002460
0.001848
0.001352
0.000962
0.000670
0.000456
0.000307
0.000204
0.000134
0.000088
0.000058
0.000038
0.000025
0.000016
0.000011
0.000007
0.000005
0.000003
0.000002
0.000001
0.000001
0.000001
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000
0.000000];

S_lucas = [380,5,81];

T_lucas_spline = SplineCmf(S_lucas,T_lucas',S_melanopsin);
S_lucas_spline = S_melanopsin;

%%

figure, hold on

plot(SToWls(S_melanopsin),T_melanopsin/max(T_melanopsin),'DisplayName','PTB')
plot(SToWls(S_lucas),T_lucas/max(T_lucas),'DisplayName','Lucas')
plot(SToWls(S_lucas_spline),T_lucas_spline/max(T_lucas_spline),'DisplayName','Lucas spline')


legend

