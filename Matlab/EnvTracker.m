clear all, close all, clc

env = importdata('EnvelopeData.mat');

dEnv = diff(env);

plot(dEnv)
hold on
plot(env)

