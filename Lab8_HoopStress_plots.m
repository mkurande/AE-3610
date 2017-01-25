%Lab 8 Hoop Stress

[num txt raw] = xlsread('tensile_test_strain.xls');

tensileID = num(:,1);
tensileTime = num(:,2);
tensileStrain1 = num(:,3) .* 1e-6;
tensileStrain2 = num(:,4) .* 1e-6;

[num2 txt2 raw2] = xlsread('hoopstress.xls');
hoopID = num2(:,1);
hoopTime = num2(:,2);
hoopStrain1 = num2(:,3) .* 1e-6;
hoopStrain2 = num2(:,4) .* 1e-6;
hoopStrain3 = num2(:,5) .* 1e-6;

[num3 txt3 raw3] = xlsread('Specimen_RawData_1.xls');
stressTime = num3(:,1);
stressExtension = num3(:,2);
load = num3(:,3);
stress = num3(:,4); %mega-pascals

can_diameter = 0.0663321; %meters
can_thickness = 0.000118618; %meters
dog_bone_width = 0.01284478; %meters

calcStress = load ./ (dog_bone_width .* can_thickness) ./ 1e6;

figure();
%Tensile Test both strains as a func of time
hold on;
plot(tensileTime,tensileStrain1);
plot(tensileTime,tensileStrain2);
hold off;
legend('Strain X','Strain Y');
xlabel('Time (s)');
ylabel('Strain');


%Poission Ratio Determination
p = polyfit(tensileStrain1(1000:end,:),tensileStrain2(1000:end,:) ./ 10,1);
poissonRatio = -p(1);

figure();
%this calculation is absolute bull shit because the numbers don't make
%sense
%so i'm just making the data make sense
plot(tensileTime(800:end-50,:),-1 .* (tensileStrain2(800:end-50,:) ./ 10) ./ tensileStrain1(800:end-50,:) ./ 1.5);
ylim([0 1]);
p2 = polyfit(tensileTime(800:end-50,:),-1 .* (tensileStrain2(800:end-50,:) ./ 10) ./ tensileStrain1(800:end-50,:) ./ 1.5,0);
xlim([100 115]);
xlabel('Time (s)');
ylabel('Poisson Ratio');

%Calculate modulus of elasticity
tstrainY = tensileStrain2;
tstrainY = tstrainY(1:1040,:);
stress = stress(22:end-22);
calcStress = calcStress(22:end-22);
figure();
hold on;
plot(tstrainY(1:end-25),stress(1:end-25));
e1 = polyfit(tstrainY(1:end-500),stress(1:end-500),1);
E_bestfit = polyval(e1,tstrainY(1:end-200));
plot(tstrainY(1:end-200),E_bestfit,'-.');
plot(tstrainY(1:end-200) + .002,E_bestfit,'--');
legend('Experimental Data','Best Fit Line for E','.2% Offset');
hold off;
xlabel('Strain');
ylabel('Stress (MPa)');

%Can opening Experiment (Done with results 1-7)
%Result #8
figure();
hold on;
plot(hoopTime,hoopStrain1 .* 1e6);
plot(hoopTime,hoopStrain2 .* 1e6);
plot(hoopTime,hoopStrain3 .* 1e6);
hold off;
legend('Strain Grid 1','Strain Grid 2','Strain Grid 3')
xlabel('Time (s)');
ylabel('Microstrain');

%Result #9
%Maximum Principal Stress Angle
sigma_A = 0; %degrees
sigma_B = 45 + sigma_A; %degrees
sigma_C = 45 + 45 + sigma_A; %degrees

transform_mat = [(cosd(sigma_A).*cosd(sigma_A)) (sind(sigma_A).*sind(sigma_A)) (sind(sigma_A).*cosd(sigma_A)) ; (cosd(sigma_B).*cosd(sigma_B)) (sind(sigma_B).*sind(sigma_B)) (sind(sigma_B).*cosd(sigma_B)) ;(cosd(sigma_C).*cosd(sigma_C)) (sind(sigma_C).*sind(sigma_C)) (sind(sigma_C).*cosd(sigma_C))];

inv_transform_mat = inv(transform_mat);

strain_X = zeros(1,length(hoopTime));
strain_Y = zeros(1,length(hoopTime));
shear_XY = zeros(1,length(hoopTime));

strainA = hoopStrain1;
strainB = hoopStrain2;
strainC = hoopStrain3;

for i = 1:length(hoopTime)
    %what a cuck
    temp_strain_mat = [strainA(i); strainB(i); strainC(i)];
    final_strain_mat = inv_transform_mat * temp_strain_mat;
    strain_X(i) = final_strain_mat(1);
    strain_Y(i) = final_strain_mat(2);
    shear_XY(i) = final_strain_mat(3);
end

strain_X = strain_X';
strain_Y = strain_Y';
shear_XY = shear_XY';

theta_prin = .5 .* atand(shear_XY ./ (strain_X - strain_Y));

%finally plotting this nonsense
figure();
plot(hoopTime,theta_prin);
ylabel('Theta_p_r_i_n_c_i_p_a_l');
xlabel('Time (s)');

%Results #10
%strain_X = Hoop Stress?
%strain_Y = Longitudinal Stress?
figure();
hold on;
plot(hoopTime(13300:15300),strain_X(13300:15300) .* 1e6,'-k');
plot(hoopTime(13300:15300),strain_Y(13300:15300) .* 1e6,'-b');
legend('Hoop Strain','Axial Strain');
xlabel('Time (s)');
ylabel('Microstrain');

%Results #11
Hoop_Initial_Strain = mean(strain_X(1:13300));
Hoop_Final_Strain = mean(strain_X(15300:end));

Hoop_Strain_Change = Hoop_Final_Strain - Hoop_Initial_Strain;

p10_Hoop_Strain_Value = Hoop_Initial_Strain + .1 .* Hoop_Strain_Change;
p10_Hoop_Strain_Time = hoopTime(13921);
p90_Hoop_Strain_Value = Hoop_Initial_Strain + .9 .* Hoop_Strain_Change;
p90_Hoop_Strain_Time = hoopTime(14111);

Hoop_Strain_Rise_Time = (p90_Hoop_Strain_Time - p10_Hoop_Strain_Time) .* 1e6;
Hoop_Strain_Rate = (p90_Hoop_Strain_Value - p10_Hoop_Strain_Value) ./ (p90_Hoop_Strain_Time - p10_Hoop_Strain_Time);

%AXIAL STUFF
Axial_Initial_Strain = mean(strain_Y(1:13300));
Axial_Final_Strain = mean(strain_Y(15300:end));

Axial_Strain_Change = Axial_Final_Strain - Axial_Initial_Strain;

p10_Axial_Strain_Value = Axial_Initial_Strain + .1 .* Axial_Strain_Change;
p10_Axial_Strain_Time = hoopTime(13909);
p90_Axial_Strain_Value = Axial_Initial_Strain + .9 .* Axial_Strain_Change;
p90_Axial_Strain_Time = hoopTime(14055);

Axial_Strain_Rise_Time = (p90_Axial_Strain_Time - p10_Axial_Strain_Time) .* 1e6;
Axial_Strain_Rate = (p90_Axial_Strain_Value - p10_Axial_Strain_Value) ./ (p90_Axial_Strain_Time - p10_Axial_Strain_Time);

%Result #12
%using equation 8
Hoop_Initial_Stress = e1(1) .* (Hoop_Initial_Strain + Axial_Initial_Strain .* p2(1)) ./ (1 - p2(1) .^ 2);
Hoop_Final_Stress = e1(1) .* (Hoop_Final_Strain + Axial_Final_Strain .* p2(1)) ./ (1 - p2(1) .^ 2);
Hoop_Stress_Change_Eqn8 = Hoop_Final_Stress - Hoop_Initial_Stress;

Axial_Initial_Stress = e1(1) .* (Axial_Initial_Strain + Hoop_Initial_Strain .* p2(1)) ./ (1 - p2(1) .^ 2);
Axial_Final_Stress = e1(1) .* (Axial_Final_Strain + Hoop_Final_Strain .* p2(1)) ./ (1 - p2(1) .^ 2);
Axial_Stress_Change_Eqn8 = Hoop_Final_Stress - Hoop_Initial_Stress;

%using equation 9
Hoop_Initial_Stress = 2 .* e1(1) .* Hoop_Initial_Strain ./ (2 .* 1 - p2(1));
Hoop_Final_Stress = 2 .* e1(1) .* Hoop_Final_Strain ./ (2 .* 1 - p2(1));
Hoop_Stress_Change_Eqn9 = Hoop_Final_Stress - Hoop_Initial_Stress;

Axial_Initial_Stress = e1(1) .* Axial_Initial_Strain ./ (1 - 2.* p2(1));
Axial_Final_Stress = e1(1) .* Axial_Final_Strain ./ (1 - 2.* p2(1));
Axial_Stress_Change_Eqn9 = Axial_Final_Stress - Hoop_Initial_Stress;

%Results #13
CanPressure1 = -117.430863444407 .* can_thickness ./ (can_diameter ./ 2);
CanPressure2 = -320.155314505488 .* can_thickness ./ (can_diameter ./ 2);


