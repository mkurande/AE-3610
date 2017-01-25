% Apr/2014 Zhangxian Yuan
% AE 3145 Structures Laboratory
% This script is used to import the ARAMIS data into Matlab
% The export data file has 17 columns



clc; clear all;
% CHANGE the file name when using different data file!!!
[c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16] = textread('Open Hole Tension-Stage-0-2.txt','%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','headerlines',14);

x_min=min(c1); % minimum value of index_x (minimum horizontal pixel coordinate of subsets)
x_max=max(c1); % maximum value of index_x (maximum horizontal pixel coordinate of subsets)

y_min=min(c2); % minimum value of index_y (minimum vertical pixel coordinate of subsets)
y_max=max(c2); % maximum value of index_y (maximum vertical pixel coordinate of subsets)

x_num=x_max-x_min+1; % max POSSIBLE number of subsets (facets) along the horizontal direction 
y_num=y_max-y_min+1; % max POSSIBLE number of subsets (facets) along the vertical direction

point_num=length(c1); % total number of subsets (facets) in the data set obtained from 'length' of c1
point_num2=length(c2);% total number of subsets (facets) in the data set obtained from 'length" of c2 (same value as obtained using previous line)
%NOTE: previous two lines calculate the total number ofsubsets(facets) which
% which is likely less than x_num*y_num since there are "holes" at some
% coordinate locations where no DIC data was obtained. 

XcoordIni= NaN(x_num,y_num);   % creates an initialized array of NaN(Not-a-Number) of size x_num x y_num for the UNDEFORMED X coord in column c3
YcoordIni= NaN(x_num,y_num);   % creates an initialized array of NaN(Not-a-Number) of size x_num x y_num for the UNDEFORMED Y coord in column c4
ZcoordIni= NaN(x_num,y_num);   % creates an initialized array of NaN(Not-a-Number) of size x_num x y_num for the UNDEFORMED Z coord in column c5

XcoordDef= NaN(x_num,y_num);   % creates an initialized array of NaN(Not-a-Number) of size x_num x y_num for the DEFORMED X coord in column c6
YcoordDef= NaN(x_num,y_num);   % creates an initialized array of NaN(Not-a-Number) of size x_num x y_num for the DEFORMED Y coord in column c7
ZcoordDef= NaN(x_num,y_num);   % creates an initialized array of NaN(Not-a-Number) of size x_num x y_num for the DEFORMED Z coord in column c8

Xdis= NaN(x_num,y_num);        % creates an initialized array of NaN(Not-a-Number) of size x_num x y_num for the array for the X DISP in column c9
Ydis= NaN(x_num,y_num);        % creates an initialized array of NaN(Not-a-Number) of size x_num x y_num for the array for the Y DISP in column c10
Zdis= NaN(x_num,y_num);        % creates an initialized array of NaN(Not-a-Number) of size x_num x y_num for the array for the Z DISP in column c11

Xstrain= NaN(x_num,y_num);     % creates an initialized array of NaN(Not-a-Number) of size x_num x y_num for the array for epsilon_X STRAIN in column c12
Ystrain= NaN(x_num,y_num);     % creates an initialized array of NaN(Not-a-Number) of size x_num x y_num for the array for epsilon_Y STRAIN in column c13
XYstrain= NaN(x_num,y_num);

MajorStrain= NaN(x_num,y_num);        % creates an initialized array of NaN(Not-a-Number) of size x_num x y_num for the array for epsilon_1 (MAX STRAIN) in column c14
MinorStrain= NaN(x_num,y_num);        % creates an initialized array of NaN(Not-a-Number) of size x_num x y_num for the array for epsilon_2 (MAX STRAIN) in column c15
%ThickRedu= NaN(x_num,y_num);        % creates an initialized array of NaN(Not-a-Number) of size x_num x y_num for the array for epsilon_3 (MAX STRAIN) in column c16


for i=1:point_num
  row    = c1(i)-x_min+1; % resets the row index of the data for plotting all of the various quantities so that the first row index is 1
  column = c2(i)-y_min+1; % resets the row index of the data for plotting all of the various quantities so that the first row index is 1
  
  
XcoordIni(row,column) = c3(i);   % Replaces the intial NaN (placeholder) at the (row,column) matrix location in XcoordIni(x_num,y_num)with the corresponding UNDEFORMED X coord in column c3
YcoordIni(row,column) = c4(i);   % Replaces the intial NaN (placeholder) at the (row,column) matrix location in XcoordIni(x_num,y_num)with the corresponding UNDEFORMED Y coord in column c4
ZcoordIni(row,column) = c5(i);   % Replaces the intial NaN (placeholder) at the (row,column) matrix location in XcoordIni(x_num,y_num)with the corresponding UNDEFORMED Z coord in column c5

XcoordDef(row,column) = c6(i);   % Replaces the intial NaN (placeholder) at the (row,column) matrix location in XcoordIni(x_num,y_num)with the corresponding DEFORMED X coord in column c6
YcoordDef(row,column) = c7(i);   % Replaces the intial NaN (placeholder) at the (row,column) matrix location in XcoordIni(x_num,y_num)with the corresponding DEFORMED Y coord in column c7
ZcoordDef(row,column) = c8(i);   % Replaces the intial NaN (placeholder) at the (row,column) matrix location in XcoordIni(x_num,y_num)with the corresponding DEFORMED Z coord in column c8

Xdis(row,column) = c9(i);        % Replaces the intial NaN (placeholder) at the (row,column) matrix location in XcoordIni(x_num,y_num)with the corresponding X DISP in column c9
Ydis(row,column) = c10(i);       % Replaces the intial NaN (placeholder) at the (row,column) matrix location in XcoordIni(x_num,y_num)with the corresponding Y DISP in column c10
Zdis(row,column) = c11(i);       % Replaces the intial NaN (placeholder) at the (row,column) matrix location in XcoordIni(x_num,y_num)with the corresponding Z DISP in column c11

 if c12(i) ~=0     % some points in ARAMIS might only have displacement results but don't have strain results
  Xstrain(row,column) = c12(i);    % Replaces the intial NaN (placeholder) at the (row,column) matrix location in XcoordIni(x_num,y_num)with the corresponding epsilon_X STRAIN in column c12
  Ystrain(row,column) = c13(i);    % Replaces the intial NaN (placeholder) at the (row,column) matrix location in XcoordIni(x_num,y_num)with the corresponding epsilon_Y STRAIN in column c13
  XYstrain(row,column) = c14(i);   % Replaces the intial NaN (placeholder) at the (row,column) matrix location in XcoordIni(x_num,y_num)with the corresponding epsilon_Y STRAIN in column c14

  MajorStrain(row,column) = c15(i);       % Replaces the intial NaN (placeholder) at the (row,column) matrix location in XcoordIni(x_num,y_num)with the corresponding epsilon_1 (Major STRAIN) in column c15
  MinorStrain(row,column) = c16(i);       % Replaces the intial NaN (placeholder) at the (row,column) matrix location in XcoordIni(x_num,y_num)with the corresponding epsilon_2 (Minor STRAIN) in column c16
%  ThickRedu(row,column) = c17(i);        % Replaces the intial NaN (placeholder) at the (row,column) matrix location in XcoordIni(x_num,y_num)with the corresponding epsilon_3 (Thicknessreduction) in column c17
 end

end
E_tension = 5110.78873050731;

YcoordDef = YcoordDef(12:31,13:end-1);
XcoordDef = XcoordDef(12:31,13:end-1);

Xstrain = Xstrain(12:31,13:end-1);
Ystrain = Ystrain(12:31,13:end-1);
XYstrain = XYstrain(12:31,13:end-1);

Xstress = E_tension .* Xstrain;
Ystress = E_tension .* Ystrain;
XYstress = E_tension .* XYstrain;

XcoordDef = XcoordDef - 18.3;

theta = atan(YcoordDef ./ XcoordDef); %idk if this is even right
r = sqrt(YcoordDef .* YcoordDef + XcoordDef .* XcoordDef); %the fuck am I doing

stressRR = (cos(theta)).^2 .* Xstress + 2 .* sin(theta) .* cos(theta) .* XYstrain + (sin(theta)).^2 .* Ystress;

stressOO = (1 ./ (r .* r)) .* ((sin(theta)).^2 .* Xstress + 2 .* sin(theta) .* cos(theta) .* XYstress + (cos(theta)).^2 .* Ystress);

%figure();
%image(Xstrain,'CDataMapping','scaled');
%colorbar;

%figure();
%image(Ystrain,'CDataMapping','scaled');
%colorbar;

%figure();
%image(Xstress,'CDataMapping','scaled');
%colorbar;

%figure();
%image(Ystress,'CDataMapping','scaled');
%colorbar;

%figure();
%image(stressRR,'CDataMapping','scaled');
%colorbar;

%figure();
%image(stressOO,'CDataMapping','scaled');
%colorbar;

%Results #11
tang_stress_perp_length = stressOO(:,44)';
xvals = XcoordDef(:,44)';
%plot(xvals,tang_stress_perp_length,'-k');
%xlabel('X Location');
%ylabel('Tangential Stress (psi)');

%Results #12
tang_stress_close_hole = [-52.5859148744902 -43.4011420740958 -15.5410942278058 109.232413647949 229.201076673840 299.11980710973 206.775331275729 73.5275506512152 -80.7876668013835 -278.758508144211 -77.6800963616154 306.878309950537 273.473053682936 214.880550970657 124.536899048694 -2.58567843773641 -40.7885675841072];
theta_close_hole = [-1.54517874374947 1.35648750401429 1.02418023973395 0.639168268372248 0.386926333423302 0.0752092511053417 -0.247060983908687 -0.714391861555008 -1.04663561656030 -1.56043101305277 1.07396843987390 0.404015114487121 -0.0435068726893739 -0.349908717682287 -0.795781587179494 -0.976083298726373 -1.30670093894359];
plot(theta_close_hole,tang_stress_close_hole,'ok');
xlabel('Theta');
ylabel('Tangential Stress Near Hole (psi)');
xlim([-1.5 1.5]);
