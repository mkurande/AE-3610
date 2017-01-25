%I still hate this class
%but at least the structures labs arent as bad as the fluids labs
%kennedy is a good guy

[num txt raw] = xlsread('F2_Lab5_data.xls');

num = num(3:end,2:end);

long_data = num(1:10,:);
short_data = num(14:end,:);

long_column_loads = long_data(:,1);
long_column_strain1 = long_data(:,2) .* 1e-6; %strain (not microstrain)
long_column_strain2 = long_data(:,3) .* 1e-6;
long_column_bendingstrain = long_data(:,4) .* 1e-6;

long_column_length = 29; %inches
long_column_width = .75; %inches
long_column_thickness = .50; %inches

short_column_loads = short_data(:,1);
short_column_strain1 = short_data(:,2) .* 1e-6;%strain (not microstrain)
short_column_strain2 = short_data(:,3) .* 1e-6;
short_column_bendingstrain = short_data(:,4) .* 1e-6;

short_column_length = 24; %inches
short_column_width = .75; %inches
short_column_thickness = .50; %inches

%creating the southwell plots for strain
%y axis = bending strain
%x axis = bending strain / load
%slope of the graph should be P_critical

%long column southwell plot
plot(long_column_bendingstrain ./ long_column_loads, long_column_bendingstrain,'ob');
xlabel('Bending Strain / Loads (1/lbf)');
ylabel('Strain');
p1 = polyfit(long_column_bendingstrain ./ long_column_loads, long_column_bendingstrain,1);
%P_critical is slope = 943.1862 lbf
long_column_buckling_stress = p1(1) ./ (long_column_width * long_column_thickness);
%stress_critical = 2515.16314694854 psi

%short column southwell plot
figure();
plot(short_column_bendingstrain ./ short_column_loads, short_column_bendingstrain,'ob');
xlabel('Bending Strain / Loads (1/lbf)');
ylabel('Strain');
p2 = polyfit(short_column_bendingstrain ./ short_column_loads, short_column_bendingstrain,1);
%P_critical is slope = 1362.6908 lbf
short_column_buckling_stress = p2(1) ./ (short_column_width * short_column_thickness);
%stress_critical = 3633.84234352842 psi

aluminum_youngs_modulus = 10600e3; %psi

long_column_moment_of_inertia = (long_column_thickness .^3) .* (long_column_width) ./ 12; % in^4
long_column_theoretical_critical_load = pi .* pi .* aluminum_youngs_modulus .* long_column_moment_of_inertia ./ (long_column_length .^2);
long_column_theoretical_critical_stress = long_column_theoretical_critical_load ./ (long_column_thickness .* long_column_width);
long_column_radius_of_gyration = sqrt(long_column_moment_of_inertia ./ (long_column_thickness .* long_column_width));
long_column_slenderness_ratio = long_column_length ./ long_column_radius_of_gyration;

short_column_moment_of_inertia = (short_column_thickness .^3) .* (short_column_width) ./ 12; % in^4
short_column_theoretical_critical_load = pi .* pi .* aluminum_youngs_modulus .* short_column_moment_of_inertia ./ (short_column_length .^2);
short_column_theoretical_critical_stress = short_column_theoretical_critical_load ./ (short_column_thickness .* short_column_width);
short_column_radius_of_gyration = sqrt(short_column_moment_of_inertia ./ (short_column_thickness .* short_column_width));
short_column_slenderness_ratio = short_column_length ./ short_column_radius_of_gyration;





%create the Euler Hyperbola Plot (setup)
slender_ratios = linspace(20,300) %50 for slender ratios for short columns, 250+ for long columns
critical_stresses = (pi ./ slender_ratios) .^ 2 .* aluminum_youngs_modulus;
particular_slender_ratios = [long_column_slenderness_ratio short_column_slenderness_ratio]
theoretical_particular_stresses = [long_column_theoretical_critical_stress short_column_theoretical_critical_stress]
analytical_particular_stresses = [long_column_buckling_stress short_column_buckling_stress]

%Euler Hyperbola Plot creation
figure();
plot(slender_ratios,critical_stresses,'-b',particular_slender_ratios,analytical_particular_stresses,'ok',particular_slender_ratios,theoretical_particular_stresses,'*r');
xlim([0 300]);
ylim([0 50000]); %50,000 psi for the tensile yield for aluminum 2024-T3
xlabel('Slenderness Ratio');
ylabel('Critical Stress (psi)');
legend('Euler Hyperbola for Aluminum 2024-T3','Theoretical Critical Stresses','Experimental Critical Stresses');

