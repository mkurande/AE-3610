[num txt raw] = xlsread('Lab6data_formatted.xlsx');

LDV_vert_positions = num(:,1); %inches
LDV_velocity = num(:,2); %m/s
LDV_vel_rms = num(:,3); %m/s
LDV_sample_size = num(:,4); %counts

%At Location of 1" instantaneous velocities
LDV_location_1_time = num(:,5);
LDV_location_1_inst_vel = num(:,6);


%At Location of 2" instantaneous velocities
LDV_location_2_time = num(:,7);
LDV_location_2_inst_vel = num(:,8);

%At other locations of interest
LDV_location_0_inst_vel = num(:,9);
LDV_location_0_5_inst_vel = num(:,10);
LDV_location_1_75_inst_vel = num(:,11);
LDV_location_2_5_inst_vel = num(:,12);
LDV_location_3_inst_vel = num(:,13);

%Repeated runs
LDV_location_3_repeat = num(:,14);
LDV_location_1_repeat = num(:,15);

%other data for comparisons
LDV_run11 = num(:,16);
LDV_run12 = num(:,17);
LDV_run13 = num(:,18);
LDV_run14 = num(:,19);
LDV_run15 = num(:,20);
LDV_run16 = num(:,21);


%freestream calculation
LDV_freestream_velocity = (3.751488 + 4.105054) ./ 2; %m/s (using the average of the two mean values for freestream velocities)

%results #2 plot - normalized axial velocity profile
LDV_normalized_axial_velocity = LDV_velocity ./ LDV_freestream_velocity;
sys_error = sqrt((.000001 / 2)^2 + (.00025)^2 + (.001)^2);
rand_error = LDV_vel_rms ./ sqrt(LDV_sample_size);
total_error = 1.96 .* (sys_error + rand_error); %95 percent confidence interval
%plot(LDV_vert_positions,LDV_normalized_axial_velocity,'ob');
errorbar(LDV_vert_positions,LDV_normalized_axial_velocity,total_error,'ob');
xlabel('LDV Location (in)');
ylabel('U/U_i_n_f');

%results #3 - normalized turbluence intensity profiles in the jet
%first way = u_rms / u_infinity
%second way = u_rms / U
figure();
hold on;
LDV_normalized_turbulence_freestream = LDV_vel_rms ./ LDV_freestream_velocity;
LDV_normalized_turbulence_true_velocity = LDV_vel_rms ./ LDV_velocity;
%plot(LDV_vert_positions,LDV_normalized_turbulence_freestream,'ob',LDV_vert_positions,LDV_normalized_turbulence_true_velocity,'sr');
total_error = total_error ./ LDV_freestream_velocity;
errorbar(LDV_vert_positions,LDV_normalized_turbulence_freestream,total_error,'ob');
errorbar(LDV_vert_positions,LDV_normalized_turbulence_true_velocity,total_error,'sr');
xlabel('LDV Locaiton (in)');
ylabel('Normalized Turbulence Intensity');
legend('U_r_m_s / U_i_n_f','U_r_m_s / U','Location','northwest');
hold off;

%results #4
%what should the instantaneous velocity be plotted with at those two
%locations?
%the two locations are: 
%   1. In Free Stream (1")
figure();
plot(LDV_location_1_time, LDV_location_1_inst_vel,'.k');
xlabel('Time (s)');
ylabel('Instantenous Velocity (m/s)');
ylim([0,12]);
legend('1" location"');
%   2. In Jet Shear Layer (2")
figure();
plot(LDV_location_2_time, LDV_location_2_inst_vel,'.k')
xlabel('Time (s)');
ylabel('Instantenous Velocity (m/s)');
ylim([0,12]);
xlim([0,21]);
legend('2" location"');

%Results #5 = Histograms at interesting points in the flow
%   1. at 0"
figure();
histogram(LDV_location_0_inst_vel);
ylabel('Frequency');
xlabel('Velocity');
legend('0" location"');
%   2. at .5"
figure();
histogram(LDV_location_0_5_inst_vel);
ylabel('Frequency');
xlabel('Velocity');
legend('0.5" location"');
%   3. at 1"
figure();
histogram(LDV_location_1_inst_vel);
ylabel('Frequency');
xlabel('Velocity');
legend('1" location"');
%   4. at 1.75"
figure();
histogram(LDV_location_1_75_inst_vel);
ylabel('Frequency');
xlabel('Velocity');
legend('1.75" location"');
%   5. at 2"
figure();
histogram(LDV_location_2_inst_vel);
ylabel('Frequency');
xlabel('Velocity');
legend('2" location"');
%   6. at 2.5"
figure();
histogram(LDV_location_2_5_inst_vel);
ylabel('Frequency');
xlabel('Velocity');
legend('2.5" location"');
%   7. at 3.0"
figure();
histogram(LDV_location_3_inst_vel);
ylabel('Frequency');
xlabel('Velocity');
legend('3" location"');

%Results #6
%comparison between points taken with:
%   different filter
%       Between Run 11 & Run 3 (1" one)
figure();
hold on;
histogram(LDV_run11);
histogram(LDV_location_1_repeat);
hold off;
legend('.3 - 3 MHz / 40 MHz','1 - 10 MHz / 39 MHz');

%       Between Run 12 & Run 8 (2" one)
figure();
hold on;
histogram(LDV_run12);
histogram(LDV_location_2_inst_vel);
hold off;
legend('.3 - 3 MHz / 40 MHz','1 - 10 MHz / 39 MHz');

%   burst threshold
%       Between Run 13 & Run 8 (2" one)
figure();
hold on;
histogram(LDV_run13);
histogram(LDV_location_2_inst_vel);
hold off;
legend('150mV','30mV');

%   seeder settings
%       Between Run 14 (freestream seeder off) & Run 15 (jet seeder off)
figure();
hold on;
histogram(LDV_run14);
histogram(LDV_run15);
hold off;
legend('Freestream Seeder Off','Jet Seeder Off');

%Results #7
%comparison between axial and vertical velocities
%       Between Run 16 & Run 8 (2" one)
figure();
hold on;
histogram(LDV_run16);
histogram(LDV_location_2_inst_vel);
hold off;
legend('Vertical Velocity','Axial Velocity');

%Result for Error Analysis
%   compare histograms for 1"
figure();
hold on;
histogram(LDV_location_1_inst_vel);
histogram(LDV_location_1_repeat);
hold off;
legend('1"','1"');

%   compare histograms for 3"
figure();
hold on;
histogram(LDV_location_3_inst_vel);
histogram(LDV_location_3_repeat);
hold off;
legend('3"','3"');
























