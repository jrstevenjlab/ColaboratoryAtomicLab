% All text preceded by percent sign (%) are comments and not executed code 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read data from Excel spreadsheet %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wednesday afternoon data is on Sheet 1
data_wed=xlsread('SkittlesData.xlsx', 1) 
xw=data_wed(:,1); % first column is group number (x-axis variable)
yw=data_wed(:,2); % second column is average volume (y-axis variable)
eyw=data_wed(:,3); % thrid column is averge volume std. dev. (y-axis error)

% Similar procedure for Thursday morning (on sheet 2)
data_thurs_morn=xlsread('SkittlesData.xlsx', 2) 
xt_morn=data_thurs_morn(:,1)+0.1;
yt_morn=data_thurs_morn(:,2);
eyt_morn=data_thurs_morn(:,3);

% Similar procedure for Thursday afternoon (on sheet 3)
data_thurs_aftn=xlsread('SkittlesData.xlsx', 3) 
xt_aftn=data_thurs_aftn(:,1)-0.1;
yt_aftn=data_thurs_aftn(:,2);
eyt_aftn=data_thurs_aftn(:,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot data from all days %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use Wednesday afternoon class's data as an example
% Call the errorbar() function, passing it the following variables:
%   x-axis (xw) and y-axis (yw) quantities and y-axis error bar (eyw)  
%   '.r' shows the data as points and in red color
%   'MarkerSize', 30 gives the size of the datapoints on the graph
errorbar(xw,yw,eyw,'.r','MarkerSize',30);
hold on; % this will prevent the next call to error bar from overwriting

% similar plots for Thursday morning and afternoon data (different colors)
errorbar(xt_morn,yt_morn,eyt_morn,'.k','MarkerSize',30);
hold on; % this will prevent the next call to error bar from overwriting
errorbar(xt_aftn,yt_aftn,eyt_aftn,'.b','MarkerSize',30);
hold off;

% set labels for x- and y-axes
xlabel('group number','FontSize',20);
ylabel('skittle volume \pm 1\sigma (cm^3)','FontSize',20);
ylim([0.0,1.6]); % sets the scale on the y-axis from 0 to 1 cm^3

% create legend in same order that errorbar functions were called above
legend({'Wednesday Afternoon','Thursday Morning','Thursday Afternoon'},'FontSize',20);

%return

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fit data from all days %
%%%%%%%%%%%%%%%%%%%%%%%%%%

% First define function to fit the data, in this case linear: y(x) = a + b*x
ft=fittype('a+b*x')

% Fit the Wednesday data with our function ft, passing it the following variables:
%   x-axis (xw) and y-axis (yw) data, fit function ft, and
%   weights for each data point given by 1/sigma^2, for a chi^2 fit
%   Startpoint for function parameters are initial guess for f(x) parameters a = 0.75 and b = 0 
[fitresultw,gofw] = fit(xw,yw,ft,'Weights',power(eyw,-2),'Startpoint',[0.75 0]);

% Similar fits for Thursday classes
[fitresult_thurs_morn,gof_thurs_morn] = fit(xt_morn,yt_morn,ft,'Weights',power(eyt_morn,-2),'Startpoint',[0.75 0]);
[fitresult_thurs_aftn,gof_thurs_aftn] = fit(xt_aftn,yt_aftn,ft,'Weights',power(eyt_aftn,-2),'Startpoint',[0.75 0]);

% fitresult is a function, here f(x)=a+b*x, which we can call
fitresultw % this displays fit result (best values for parameters a and b
gofw % this displays the goodness of fit

% "confidence interval" which gives uncertainties on model parameters (a and b)
confint(fitresultw, 0.68)
hold on;

% Plot fit results on the same figure as the data points
groups=1:10; % specify x-axis range for 
plot(groups,fitresultw(groups),'-r','HandleVisibility','off');
plot(groups,fitresult_thurs_morn(groups),'-k','HandleVisibility','off');
plot(groups,fitresult_thurs_aftn(groups),'-b','HandleVisibility','off');
