%Lab2_plots

%Convert thermocouple voltages to temperatures
%In data range of 0 to 500 deg C or 0-20,644 micro volts

p_low = [-1.052755e-35 1.057734e-30 -4.413030e-26 9.804036e-22 -1.228034e-17 8.31527e-14 -2.503131e-10 7.860106e-8 2.508355e-2 0];
%remember V is in micro volts
%above 500 C or above 20,644 micro volts
p_high = [-3.110810e-26 8.802193e-21 -9.650715e-16 5.464731e-11 -1.646031e-6 4.830222e-2 -1.318058e2];

%y1 = polyval(p_low, [800])
%y2 = polyval(p_low, [1800])
%y1 = polyval(p_low, [1300])


%Now to pull in the data from the excel file

[num, txt, raw] = xlsread('f2lab2.xls');

ambient_press = num(:,1); %in psi
ambient_temp = num(:,2); %in fahrenheit
fuel_rate_volt = num(:,3); %in volts
rpm = num(:,4); %in rpm

temp_2 = num(:,5); %in F
temp_3 = num(:,6); %in F
temp_4 = num(:,7); %in F
temp_5 = num(:,8); %in F
temp_e = num(:,9); %in F

press_2 = num(:,10); %in psi (why is this one different????)
press_3 = num(:,11); %in psig
press_4 = num(:,12); %in psig
press_5 = num(:,13); %in psig
press_e = num(:,14); %in psig

%temperature conversions
temp_2a = (temp_2 - 32).*(5 ./ 9 ); %in C
temp_3a = (temp_3 - 32).*(5 ./ 9 ); %in C
temp_4a = (temp_4 - 32).*(5 ./ 9 ); %in C
temp_5a = (temp_5 - 32).*(5 ./ 9 ); %in C
temp_ea = (temp_e - 32).*(5 ./ 9 ); %in C

%pressure conversions
DP2 = press_2 * 6894.76; %in Pa
press_2a = press_2 + ambient_press; %already in psi (but that doesn't seem right so I'm adding the ambient_pressure)
press_3a = press_3 + ambient_press; %in psi
press_4a = press_4 + ambient_press; %in psi
press_5a = press_5 + ambient_press; %in psi
press_ea = press_e + ambient_press; %in psi

%Air mass flow rate
%m_dot = ro x velocity x area
compressor_inlet_cir = .223; %in meters
compressor_radius = compressor_inlet_cir ./ (2 * pi);
area_compressor_inlet = compressor_radius * compressor_radius * pi; %in meters squared
air_density = 1.225; %kg / m^3
flow_speed_c_inlet = sqrt(2 * DP2 / air_density) %in m/s
air_m_dot = air_density * flow_speed_c_inlet * area_compressor_inlet %in kg/s

%fuel mass flow rate
fuel_rate_volt_cal = [1.7 2.2 2.8 3.0];
fuel_rate_flowrate_cal = [175 227 255 300];
p = polyfit(fuel_rate_volt_cal,fuel_rate_flowrate_cal,1);
fuel_rate = polyval(p,fuel_rate_volt); %in cc/min
fuel_rate = fuel_rate / 60; %in cc/s
fuel_rate = fuel_rate * 1e-6; %in m^3/s
fuel_density = 775; %kg/m^3
fuel_m_dot = fuel_density * fuel_rate %kg/s

%to find compressor efficiency
gamma = 1.4;
n_compressor = (((press_3a./press_2a).^((gamma - 1)/gamma) - 1)./((temp_3a./temp_2a) - 1))

%static pressure at exit is ambient pressure
P_e = 14.258; %in psi
P_e = P_e * 6894.76; %in Pa

%to find the heat loss rate across the nozzle
cp_air_avg = 1.127;
q_dot = cp_air_avg .* (fuel_m_dot + air_m_dot).* (temp_ea - temp_5a)

%to find the exit velocity at nozzle exits
press_ea = press_ea * 6894.76; %in Pa
vel_exit = sqrt((press_ea - P_e) * 2 / air_density) %in m/s

%To find compressor power
cp_air_avg_compress = 1.002;
P_comp = air_m_dot .* cp_air_avg_compress .* (temp_3a - temp_2a)

%to find turbine power
cp_combined = 1.173;
P_turb = (fuel_m_dot + air_m_dot) .* cp_combined .* (temp_4a - temp_5a)

%to find the total thermal efficiency
HV = 45e6; %J/kg
N_total = ((fuel_m_dot + air_m_dot) .* (vel_exit .^ 2))  ./ (2 * fuel_m_dot * HV)


%Plots I need to make
%1. Compressor Pressure Ratio vs Air Mass Flowrate
%2. Compressor Efficiency vs Air Mass Flowrate
%3. Heat Loss in Nozzle vs. Air Mass Flowrate
%4. Engine Thermal Efficiency vs Compressor Pressure Ratio
%5. Thrust Specific Fuel Consumption vs RPM

compressor_pressure_ratio = (press_3a./press_2a);

figure()

plot(air_m_dot,compressor_pressure_ratio);
xlabel('Air Mass Flowrate (kg/s)');
ylabel('Compressor Pressure Ratio');

figure()

plot(air_m_dot,n_compressor);
xlabel('Air Mass Flowrate (kg/s)');
ylabel('Compressor Efficiency');

figure()

plot(air_m_dot,q_dot);
xlabel('Air Mass Flowrate (kg/s)');
ylabel('Heat Lost in Nozzle (J/s)');

figure()

plot(compressor_pressure_ratio,N_total);
xlabel('Compressor Pressure Ratio');
ylabel('Engine Thermal Effiency');

figure()

engine_thrust = (fuel_m_dot + air_m_dot) .* vel_exit;
TSFC = fuel_m_dot ./ engine_thrust;
plot(rpm, TSFC)
xlabel('Fuel Mass Flowrate (kg/s)');
ylabel('TSFC (m/s)');

