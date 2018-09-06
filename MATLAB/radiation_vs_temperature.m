% radiation vs. temperature
% x = temperature(K)
x = [800;1000;1200;1300;1500;1600;1700;1800;1800;1900;2000;2000];

% y = radiation sensor(W/m^2)
y = [7.95;19.32;43.18;62.50;92.05;125.0;161.36;200.0;240.91;284.09;329.55;377.27];
ey=0.05.*y; % this is bogus and made up for convenience!!! Use your actual estimate.

% define an "anonymous" function to represent the T^4 behavior we expect
% our data to follow.
% B = a background term, the value the data would have at T=0
% C = a scale factor which multiplies (T)^n. It translates the units
% from temperature^n to radiated power
% n = the power in the power law. Should be 4.
f = @(C,n,x) C*power(x,n); % our function

%Below: plot the data, plot an estimate of the best fit, fit the data, then
%plot the best fit.
f1=figure(1);
hold on; % allow multiple plots on the same figure
%%% plot the data
errorbar(x,y,ey,'.k','Markersize',20);
%%% now do the fit.
[fit1, gof]=fit(x,y,f,'Weight',power(ey,-2),'Startpoint',[0 4],'Upper',[inf inf]);
fit1 % without the trailing ; this prints the result of the fit in the command window
%%% now plot the fit
plot(x,fit1(x),'--r')
%%% label axes and make a legend
xlabel('Temperature (Kelvin)');
ylabel('radiated power (W/m^2)');
legend({'Our data','best fit'},'FontSize',20,'Location','northeast');
hold off;

% now plot residuals of the fit. This is easier than it seems
f2=figure(2);
errorbar(x,(fit1(x)-y)./ey,ones(1,length(x))','.k','markersize',20) %the ones() thing does the error bars
xlabel('Temperature (Kelvin)');
ylabel('residual = (data - best fit) / uncertainty on data'); 

% get 68% confidence intervals. This is what we normally think of as "1
% sigma"
ci=confint(fit1,0.68)
sprintf('At best fit, n = %f',fit1.n)
sprintf('68%% confidence interval for n = [%f, %f]',ci(1,2),ci(2,2)) 
