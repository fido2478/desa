function [voltage]=emulate_voltagechange(min_pw,discharge,soc)
% input: dischage(coulomb), soc = [0 1]
% process: calculate corresponding voltage
% output: voltage
%   Time     Util N  Util P  Cell Pot   Uocp      Curr      Temp   heatgen
%   (min)       x       y      (V)       (V)      (A/m2)    (C)    (W/m2)
% This is a curve fitting of a function of discharge rate and time

voltage=polyval2(min_pw,discharge,soc);