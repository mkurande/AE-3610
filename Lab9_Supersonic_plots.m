%Lab 9 Data Reduction and Plots

[num txt raw] = xlsread('F2_calibration.xls');
%Values are in volts
% -0.45V + 100 Torr/Volt

calibration_data = num(:,1:10);

p = zeros(2,length(calibration_data));

for i = 1:length(calibration_data)
    
    x = num(:,i);
    y = [7 14 0]'; %Torr
    temp = polyfit(x,y,1);
    p(1,i) = temp(1);
    p(2,i) = temp(2);
    
end

%Probably not right... need to figure out how to use the calibration data
sensitivity = p(1,:);
null_offset = p(2,:);

%atmospheric pressure
atm = 732.79011; %Torr
atm2 = 14.169797261; %psi

%Import the actual data for test 1
[num2 txt2 raw2] = xlsread('f2.supersonictest.xls');

data1 = num2(2:end,1:10); %in volts

for i = 1:4
    
   data1(i,:) = data1(i,:) .* sensitivity + null_offset; %now in psig
    
end

data1 = data1 + atm2; %now in psia

station1_static_stag_ratio1 = data1(:,2) ./ data1(:,1);
station2_static_stag_ratio1 = data1(:,3) ./ data1(:,1);

%Import Data for Test 2
[num3 txt3 raw3] = xlsread('f2.supersonictest2.xls');

data2 = num3(2:end,1:10); %in volts

for i = 1:4
    
   data2(i,:) = data2(i,:) .* sensitivity + null_offset; %now in psig
    
end

data2 = data2 + atm2; %now in psia

station1_static_stag_ratio2 = data2(:,2) ./ data2(:,1);
station2_static_stag_ratio2 = data2(:,3) ./ data2(:,1);

%Result #3
%subsonic / choked / 4 & 5 shock
table3_station1 = [.46 .85 .87];
table3_station2 = [.31 .73 .74];

%Results #4 and Data Reduction #4
stag_pressure_ratio = data1(:,10) ./ data1(:,1);
table4_station6_using_stag_ratio = [.23 .33 .98 2.21]; %kinda made up data... 

station6_static_stag_ratio1 = [data1(1:3,7) ./ data1(1:3,10); data1(4,7) ./ data1(4,1)];
table4_station6_using_static_stag_ratio1 = [.19 .29 .96 2.09];

%Results number 5

axial_distance = [0 .25 .75 1.25 1.75 2.25 2.75 3.25];
static_supply_stag_ratio1_subsonic = data1(1,2:9) ./ data1(1,1);
static_supply_stag_ratio1_shock45 = data1(3,2:9) ./ data1(3,1);
static_supply_stag_ratio1_shock6 = data1(4,2:9) ./ data1(4,1);

static_supply_stag_ratio2_subsonic = data2(1,2:9) ./ data2(1,1);
static_supply_stag_ratio2_shock45 = data2(3,2:9) ./ data2(3,1);
static_supply_stag_ratio2_shock6 = data2(4,2:9) ./ data2(4,1);

hold on;
plot(axial_distance,static_supply_stag_ratio1_subsonic,'-bo');
plot(axial_distance,static_supply_stag_ratio1_shock45,'-bs');
plot(axial_distance,static_supply_stag_ratio1_shock6,'-bd');

plot(axial_distance,static_supply_stag_ratio2_subsonic,'--ro');
plot(axial_distance,static_supply_stag_ratio2_shock45,'--rs');
plot(axial_distance,static_supply_stag_ratio2_shock6,'--rd');
hold off;
xlabel('Axial Distance (in)')
ylabel('Static Pressure to Supply Stagnation Pressure Ratio');
legend('Test 1 Subsonic','Test 1 Shock between 4 and 5','Test 1 Shock after 6','Test 2 Subsonic','Test 2 Shock between 4 and 5','Test 2 Shock after 6');
ylim([0,1.5]);

%Results #6
gam = 1.4;
%M1_subsonic = sqrt((2 .* ((static_supply_stag_ratio1_subsonic).^((-gam +1)./gam)) - 1) ./ (gam - 1)) =====DOESNOTWORK

M1_subsonic = [.439 .308 .308 .332 .296 .269 .269 .239];
M2_subsonic = [.514 .374 .374 .372 .333 .304 .306 .276];

M1_shock45 = [.867 .747 .747 1.84 1.15 .996 .996 .812];
M2_shock45 = [.866 .737 .737 1.84 1.17 1.03 1.03 .857];

M1_shock6 = [.808 .771 .773 1.76 1.81 2.09 1.79 1.17];
M2_shock6 = [.808 .767 .768 1.75 1.81 2.09 1.79 1.17];

figure();
hold on;
plot(axial_distance,M1_subsonic,'-bo');
plot(axial_distance,M1_shock45,'-bs');
plot(axial_distance,M1_shock6,'-bd');

plot(axial_distance,M2_subsonic,'--ro');
plot(axial_distance,M2_shock45,'--rs');
plot(axial_distance,M2_shock6,'--rd');
xlabel('Axial Location (in)');
ylabel('Mach Number');
legend('Test 1 Subsonic','Test 1 Shock between 4 and 5','Test 1 Shock after 6','Test 2 Subsonic','Test 2 Shock between 4 and 5','Test 2 Shock after 6');
hold off;
ylim([0,2.8]);








