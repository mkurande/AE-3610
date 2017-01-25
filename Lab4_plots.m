%idk what the fuck im doing

[num, txt, raw] = xlsread('f2Lab4_Data.xls');

num = num(2:end,:);
L1 = .0254 .* num(1,8); %in meters
L2 = .0254 .* num(2,8); %in meters
Xg = .0254 .* num(3,8); %in meters

h = .0254 .* num(5,8); %in meters
b = .0254 .* num(6,8); %in meters

num = num(2:end,1:4);

weights = num(1:8,1); %in grams
strainA_weights = num(1:8,2); %microstrain
strainB_weights = num(1:8,3); %microstrain
strainC_weights = num(1:8,4); %microstrain

displacements = num(11:17,1); %inches
%displacements = [displacements' num(19:end,1)']' 
strainA_disp = num(11:17,2);
%strainA_disp = [strainA_disp' num(19:end,2)']'
strainB_disp = num(11:17,3);
strainC_disp = num(11:17,4);

sigma_A = 30; %degrees
sigma_B = 45 + sigma_A; %degrees
sigma_C = 45 + 45 + sigma_A; %degrees

transform_mat = [(cosd(sigma_A).*cosd(sigma_A)) (sind(sigma_A).*sind(sigma_A)) (sind(sigma_A).*cosd(sigma_A)) ; (cosd(sigma_B).*cosd(sigma_B)) (sind(sigma_B).*sind(sigma_B)) (sind(sigma_B).*cosd(sigma_B)) ;(cosd(sigma_C).*cosd(sigma_C)) (sind(sigma_C).*sind(sigma_C)) (sind(sigma_C).*cosd(sigma_C))];

inv_transform_mat = inv(transform_mat);

strain_X_weights = zeros(1,length(weights));
strain_Y_weights = zeros(1,length(weights));
shear_XY_weights = zeros(1,length(weights));

loads = weights ./ 1000 .* 9.81; % in newtons

for i = 1:length(weights)
    %what a cuck
    temp_strain_mat = [strainA_weights(i); strainB_weights(i); strainC_weights(i)];
    final_strain_mat = inv_transform_mat * temp_strain_mat;
    strain_X_weights(i) = final_strain_mat(1);
    strain_Y_weights(i) = final_strain_mat(2);
    shear_XY_weights(i) = final_strain_mat(3);
end

strain_X_weights = strain_X_weights';
strain_Y_weights = strain_Y_weights';
shear_XY_weights = shear_XY_weights';

%Combined plot of strain x, strain y, and shear strain as a function of
%applied load
plot(loads,strain_X_weights,'.-r',loads,strain_Y_weights,'.-g',loads,shear_XY_weights,'.-b')
xlabel('Loads (N)');
ylabel('Strain (microstrain)');
legend('Strain X','Strain Y', 'Shear Strain XY');

mohr_center_weights = .5 .* (strain_X_weights + strain_Y_weights);
mohr_radius_weights = .5 .* sqrt((strain_X_weights - strain_Y_weights).*(strain_X_weights - strain_Y_weights) + (shear_XY_weights .* shear_XY_weights));
strain_prin_1_weights = mohr_center_weights + mohr_radius_weights;
strain_prin_2_weights = mohr_center_weights - mohr_radius_weights;
shear_XY_max_weights = 2 .* mohr_radius_weights;
theta_prin_weights = .5 .* atand(shear_XY_weights ./ (strain_X_weights - strain_Y_weights));
theta_p1_weights = theta_prin_weights;
theta_p2_weights = theta_p1_weights + 90;
theta_s1_weights = theta_prin_weights + 45;
theta_s2_weights = theta_s1_weights + 90;
poisson_ratio_weights = -strain_prin_2_weights ./ strain_prin_1_weights;

%plot of strain 1 vs loads
figure();
plot(loads, strain_prin_1_weights,'.-b')
p = polyfit(loads, strain_prin_1_weights,1);
y = polyval(p,loads);
plot(loads,y,'-k');
legend('Slope = 86.58');
xlabel('Loads (N)');
ylabel('Strain (microstrain)');

%plot of strain 2 vs loads
figure();
plot(loads, strain_prin_2_weights,'.-b');
p = polyfit(loads, strain_prin_2_weights,1);
y = polyval(p,loads);
plot(loads,y,'-k');
legend('Slope = -27.17');
xlabel('Loads (N)');
ylabel('Strain (microstrain)');

%plot of shear max vs loads
figure();
plot(loads, shear_XY_max_weights,'.-b')
p = polyfit(loads, shear_XY_max_weights,1);
y = polyval(p,loads);
plot(loads,y,'-k');
legend('Slope = 113.75');
xlabel('Loads (N)');
ylabel('Strain (microstrain)');


%Now onto the deflection part


displacements = .0254 .* displacements; %in meters

strain_X_disp = zeros(1,length(displacements));
strain_Y_disp = zeros(1,length(displacements));
shear_XY_disp = zeros(1,length(displacements));

for i = 1:length(displacements)
    %what a cuck i am
    %GO TSM
    temp_strain_mat = [strainA_disp(i); strainB_disp(i); strainC_disp(i)];
    final_strain_mat = inv_transform_mat * temp_strain_mat;
    strain_X_disp(i) = final_strain_mat(1);
    strain_Y_disp(i) = final_strain_mat(2);
    shear_XY_disp(i) = final_strain_mat(3);
end

strain_X_disp = strain_X_disp';
strain_Y_disp = strain_Y_disp';
shear_XY_disp = shear_XY_disp';

%combined plot as a function of deflection
figure();
plot(displacements,strain_X_disp,'.-r',displacements,strain_Y_disp,'.-g',displacements,shear_XY_disp,'.-b')
xlabel('Deflection (m)');
ylabel('Strain (microstrain)');
legend('Strain X','Strain Y', 'Shear Strain XY');

mohr_center_disp = .5 .* (strain_X_disp + strain_Y_disp);
mohr_radius_disp = .5 .* sqrt((strain_X_disp - strain_Y_disp).*(strain_X_disp - strain_Y_disp) + (shear_XY_disp .* shear_XY_disp));
strain_prin_1_disp = mohr_center_disp + mohr_radius_disp;
strain_prin_2_disp = mohr_center_disp - mohr_radius_disp;
shear_XY_max_disp = 2 .* mohr_radius_disp;
theta_prin_disp = .5 .* atand(shear_XY_disp ./ (strain_X_disp - strain_Y_disp));
theta_p1_disp = theta_prin_disp;
theta_p2_disp = theta_p1_disp + 90;
theta_s1_disp = theta_prin_disp + 45;
theta_s2_disp = theta_s1_disp + 90;
poisson_ratio_disp = -strain_prin_2_disp ./ strain_prin_1_disp;


%plot of strain 1 vs loads
figure();
plot(displacements, strain_prin_1_disp,'.-b')
p1 = polyfit(displacements, strain_prin_1_disp,1);
y = polyval(p1,displacements);
plot(displacements,y,'-k');
legend('Slope = 64504');
xlabel('Displacement (m)');
ylabel('Strain (microstrain)');

%plot of strain 2 vs loads
figure();
plot(displacements, strain_prin_2_disp,'.-b');
p2 = polyfit(displacements, strain_prin_2_disp,1);
y = polyval(p2,displacements);
plot(displacements,y,'-k');
legend('Slope = -19186');
xlabel('Displacement (m)');
ylabel('Strain (microstrain)');

%plot of shear max vs loads
figure();
plot(displacements, shear_XY_max_disp,'.-b')
p3 = polyfit(displacements, shear_XY_max_disp,1);
y = polyval(p3,displacements);
plot(displacements,y,'-k');
legend('Slope = 83691');
xlabel('Displacement (m)');
ylabel('Strain (microstrain)');

%Last bit of data reduction to find E and bending stiffness
strain_prin_1_weights = strain_prin_1_weights .* 1e-6;
pslope = polyfit(loads, strain_prin_1_weights,1);
pslope = pslope(1);

youngs_mod = (6.*(L2 - Xg) ./ (b .* h .* h)) ./ pslope;
youngs_mod = youngs_mod ./ 1e6;

%to find bending stiffness
youngs_mod = youngs_mod .* 1e6;
mom_area = (1./12) .* b .* h .* h .* h;
stiffness = 1./(L2 .* L2 .* L2 ./ (mom_area .* youngs_mod));

youngs_mod = youngs_mod ./ 1e6;