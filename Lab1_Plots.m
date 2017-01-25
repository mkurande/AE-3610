%SURFACE PERSSURE DISTRIBUTION DATA

[num0,txt,raw] = xlsread('Surface_Pressure_Distribution_0alpha.xls');

num0 = num0(3:end,2:end);
x_c0 = num0(:,1);
dP0 = num0(:,2);
qinf0 = num0(:,4);
cp0 = dP0 ./ qinf0;
e0 = 1.96.*((num0(:,3)./(1000.^(1/2))).^2 + (num0(:,5)./(1000.^(1/2))).^2).^(1/2);
e0 = ((e0.^2) + (.000005).^2).^(1/2);

[num8,txt,raw] = xlsread('Surface_Pressure_Distribution_8alpha.xls');

num8 = num8(3:end,2:end);
x_c8 = num8(:,1);
dP8 = num8(:,2);
qinf8 = num8(:,4);
cp8 = dP8 ./ qinf8;
e8 = 1.96.*((num8(:,3)./(1000.^(1/2))).^2 + (num8(:,5)./(1000.^(1/2))).^2).^(1/2);
e8 = ((e8.^2) + (.000005).^2).^(1/2);

[num18,txt,raw] = xlsread('Surface_Pressure_Distribution_18alpha.xls');

num18 = num18(3:end,2:end);
x_c18 = num18(:,1);
dP18 = num18(:,2);
qinf18 = num18(:,4);
cp18 = dP18 ./ qinf18;
e18 = 1.96.*((num18(:,3)./(1000.^(1/2))).^2 + (num18(:,5)./(1000.^(1/2))).^2).^(1/2);
e18 = ((e18.^2) + (.000005).^2).^(1/2);

%Now make the two figures of pressure coefficient distribution
hold all;

%errorbar(x_c0,cp0,e0,'.k');
%errorbar(x_c8,cp8,e8,'.r');
%legend('0 Degree Alpha','8 Degrees Alpha');
%set(gca,'Ydir','reverse');
%ylim([-2.5 1.5]);
%xlabel('x/c');
%ylabel('Cp');


%figure();

%errorbar(x_c0,cp0,e0,'.k');
%errorbar(x_c18,cp18,e18,'.r');
%legend('0 Degree Alpha','18 Degrees Alpha');
%set(gca,'Ydir','reverse');
%ylim([-2.5 1.5]);
%xlabel('x/c');
%ylabel('Cp');

%BOUNDARY LAYER DATA

[bldata1,txt,raw] = xlsread('Boundary_Layer_Survey_trial1_allpoints.xls');

bldata1 = bldata1(3:end,:);
delta = 3;
y = bldata1(:,1);

y_delta = y / delta;

dP = bldata1(:,2);

qinf = bldata1(:,4);

q = dP; %+qinf

T_room = 70.7; %degrees Farenheit
P_room = 29.00; %in Hg
u = sqrt(q * (T_room + 459.67)/(.0159*P_room));

u_inf = sqrt(max(dP(1:16)) * (T_room + 459.67)/(.0159*P_room)) ;

u_u_inf = u * (1 / u_inf);

e = 1.96 .* (bldata1(:,3)./((2000).^(1/2)));
e = ((e.^2) + (.00005).^2).^(1/2);

%making the plot
%figure();
%errorbar(u_u_inf,y_delta,e,'.k')
%plot(u_u_inf,y_delta,'ok');
%xlabel('u/u inf');
%ylabel('y/delta');

%WAKE DATA

[wakedata,txt,raw] = xlsread('Wake_Survey_8alpha_trial1.xls');

wakedata = wakedata(3:end,:);

y = wakedata(:,1);
q = wakedata(:,2); 

T_room = 70.7; %degrees Farenheit
P_room = 29.00; %in Hg
u = sqrt(q * (T_room + 459.67)/(.0159*P_room));

u_inf = sqrt(max(q(:)) * (T_room + 459.67)/(.0159*P_room)) 

u_u_inf = u / u_inf

e = 1.96 .* (wakedata(:,3)./((20000).^(1/2)));
e = ((e.^2) + (.05).^2).^(1/2);

%making the plot

%errorbar(u,y,e,'.k');
%xlabel('u (mph)');
%ylabel('y (inches)');

%figure();

%errorbar(u_u_inf,y,e,'.k');
%plot(u_u_inf,y,'ok');
%xlabel('u / u inf');
%ylabel('y (inches)');

















