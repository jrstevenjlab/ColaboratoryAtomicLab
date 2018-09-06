% radiation vs. distance
% x = distance(cm)
x = [100;90;80;70;60;55;50;45;42;40;38;35;32;30;28;27;26;25;24;22;20;19;18;17;16.5;16;15.5;15;14;13;12;11;10;9;5];

% y = converted sensor reading(W/m^2)
y = [1.82;2.39;2.73;3.52;4.43;5.23;5.91;6.82;7.84;8.52;9.66;10.91;12.61;13.98;16.14;17.61;19.55;21.14;22.16;26.02;30.45;35;37.39;40.45;43.41;46.93;49.32;53.18;59.09;66.36;79.32;92.73;109.2;134.2;399.43];
ey=0.05.*y % this is bogus and made up for convenience!!! Use your actual estimate.

% define an "anonymous" function to represent the 1/x^2 behavior we expect
% our data to follow.
% B = a background term, the value the data would have at x=infinity
% C = a scale factor which multiplies (x-x0)^n. It translates the units
% from distance^n to radiated power
% n = the power in the power law. Should be -2.
% x0 = maybe the filament wasn't exactly at x=0? If so, this term allows
% the fit to try and correct for that. Careful: in general we get complex
% numbers if x0>x. We'll need to limit the values that x0 can take within
% the fit. See below.
f = @(B,C,n,x0,x) B+C.*power(x-x0,n); % our function

%Below: plot the data, plot an estimate of the best fit, fit the data, then
%plot the best fit.
f1=figure(1);
hold on; % allow multiple plots on the same figure
%%% plot the data
errorbar(x,y,ey,'.k','Markersize',20);
%%% plot an estimate of the best fit. I had to play around with the
%%% parameters to get this.
plot(x,f(0,10000,-2,0,x),'--k');

%%% now do the fit.
[fit1,gof]=fit(x,y,f,'Weight',power(ey,-2),'Startpoint',[0 10000 -2 0],'Upper',[inf inf inf 4.9]);
fit1 % without the trailing ; this prints the result of the fit in the command window
gof
%%% now plot the fit
plot(x,fit1(x),'--r')
%%% label axes and make a legend
xlabel('distance (cm)');
ylabel('radiated power (W/m^2)');
legend({'Our data','our guess','best fit'},'FontSize',20,'Location','northeast');
hold off;

% now plot residuals of the fit. This is easier than it seems
f2=figure(2);
errorbar(x,(fit1(x)-y)./ey,ones(1,length(x))','.k','markersize',20) %the ones() thing does the error bars
xlabel('distance (cm)');
ylabel('residual = (data - best fit) / uncertainty on data'); 

% get 68% confidence intervals. This is what we normally think of as "1
% sigma"
ci=confint(fit1,0.68)
sprintf('At best fit, n = %f',fit1.n)
sprintf('68%% confidence interval for n = [%f, %f]',ci(1,3),ci(2,3)) 
