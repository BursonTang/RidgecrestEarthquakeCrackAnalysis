clear all; close all; clc
%% Import and process original data_UW
% read data
% Tran_or = csvread('Transect_Pnts.csv',1,0);
Tran_or = csvread('VertexInput\Transect_Pnts_woTruncate.csv',1,0);
TranwCrack_UW_or = csvread('VertexInput\Transect_Pnts_wCrack_UW_2_M6.4.csv',1,0);

%%% Note: check the order of x and y coordniates
TranwCrack_UW_or(:,6) = TranwCrack_UW_or(:,4);
TranwCrack_UW_or(:,4) = TranwCrack_UW_or(:,5);
TranwCrack_UW_or(:,5) = TranwCrack_UW_or(:,6);

% trancate data (for 2 measurement lines)
% Tran_1 is north one, line ID 5
Tran_uw_1 = Tran_or(find(Tran_or(:,2) == 5):find(Tran_or(:,2) == 6)-1,:);
TranwCrack_uw_1 = TranwCrack_UW_or(find(TranwCrack_UW_or(:,2) == 5):find(TranwCrack_UW_or(:,2) == 6)-1,:);
% Tran_2 is the south one, line ID 4
Tran_uw_2 = Tran_or(find(Tran_or(:,2) == 4):find(Tran_or(:,2) == 5)-1,:);
TranwCrack_uw_2 = TranwCrack_UW_or(find(TranwCrack_UW_or(:,2) == 4):find(TranwCrack_UW_or(:,2) == 5)-1,:);

% NOTE:************** Here the UW Crack are extracted from truncated
% transect

% TranwCrack_uw_1(end,4:5) = Tran_uw_1(end,4:5);
% TranwCrack_uw_2(end,4:5) = Tran_uw_2(end,4:5);
%%


%%%%%%%%% Line 1
% Calculate distance from the first pnts
TranwCrack_len_uw_1 = pnts2Len(TranwCrack_uw_1(:,4),TranwCrack_uw_1(:,5));

% preallocate cumulative crack width
cum_width_uw_1 = zeros(length(TranwCrack_len_uw_1),1);

% set counter, initialization
i = 1; cum_width_i = 0;

% Preallocate matrix for crack width table
table_uw_1 =[TranwCrack_uw_1(:,4:5), nan(length(TranwCrack_len_uw_1),1)];

% Calculate Cumulative Crack Width
while i <= length(TranwCrack_len_uw_1)
    
    if ~ismember( TranwCrack_uw_1(i,4),Tran_uw_1(:,4) )
        cum_width_i = cum_width_i + ( TranwCrack_len_uw_1(i+1) - TranwCrack_len_uw_1(i) );
        cum_width_uw_1(i+1:end) = cum_width_i;
        table_uw_1(i,3) = TranwCrack_len_uw_1(i+1) - TranwCrack_len_uw_1(i);
        i = i + 2;
    else
        table_uw_1(i,1:2) = NaN;
        i = i + 1;
    end
    
end

table_crack_uw_1 = table_uw_1(~isnan(table_uw_1(:,1)),:);


%%%%%%%%% Line 2
% Calculate distance from the first pnts
TranwCrack_len_uw_2 = pnts2Len(TranwCrack_uw_2(:,4),TranwCrack_uw_2(:,5));

% Preallocate cumulative crack width
cum_width_uw_2 = zeros(length(TranwCrack_len_uw_2),1);

% set counter, initialization
i = 1; cum_width_i = 0;

% Preallocate matrix for crack width table
table_uw_2 =[TranwCrack_uw_2(:,4:5), nan(length(TranwCrack_len_uw_2),1)];

% Calculate Cumulative Crack Width
while i <= length(TranwCrack_len_uw_2)
    
    if ~ismember( TranwCrack_uw_2(i,4),Tran_uw_2(:,4) )
        cum_width_i = cum_width_i + ( TranwCrack_len_uw_2(i+1) - TranwCrack_len_uw_2(i) );
        cum_width_uw_2(i+1:end) = cum_width_i;
        table_uw_2(i,3) = TranwCrack_len_uw_2(i+1) - TranwCrack_len_uw_2(i);
        i = i + 2;
    else
        table_uw_2(i,1:2) = NaN;
        i = i + 1;
    end
    
end

table_crack_uw_2 = table_uw_2(~isnan(table_uw_2(:,1)),:);
%% plot
figure(1); subplot(2,1,2); grid on;hold on;
plot(TranwCrack_len_uw_1,cum_width_uw_1,'LineWidth',2);
set(gca,'FontSize',28,'YLim',[0,0.4])

text(0,0.4, 'UW data','FontSize',20)
% title('Cumulative Crack Width Along Transect#2 M6.4 UW')
% xlabel('Horizontal Distance (m)')
% ylabel('Cumulative Crack Width (m)')


figure(2); subplot(2,1,2); grid on;hold on;
plot(TranwCrack_len_uw_2,cum_width_uw_2,'LineWidth',2);
set(gca,'FontSize',28,'YLim',[0,0.6])

text(0,0.5, 'UW data','FontSize',20)
% title('Cumulative Crack Width Along Transect#1 M6.4 UW')
% xlabel('Horizontal Distance (m)')
% ylabel('Cumulative Crack Width (m)')

%% Write data to text files_JPL
% fileID = fopen('M64_CumulativeCrackWidth_UW.txt','w');
% fprintf(fileID,'Note:The distance is measured from west to east. Unit for both distance and width are meter\n\n');
% fprintf(fileID,'%8s,    %18s\n','Distance','Cumulative Width');
% fprintf(fileID,'Line1(North)\n');
% fprintf(fileID,'%8.3f,    %18.3f\n',[TranwCrack_len_2; cum_width_2']);
% fprintf(fileID,'\n\nLine2(South)\n');
% fprintf(fileID,'%8.3f,    %18.3f\n',[TranwCrack_len_1; cum_width_1']);
% fclose(fileID);

% in excel instead
csvwrite('Output\M64_Transect1_CulmulativeWidth_UW.csv',[TranwCrack_len_uw_1', cum_width_uw_1]);
csvwrite('Output\M64_Transect2_CulmulativeWidth_UW.csv',[TranwCrack_len_uw_2', cum_width_uw_2]);
% Write crack position and corresponding width
csvwrite('Output\M64_Transect1_CrackWidth_UW.csv',table_crack_uw_1);
csvwrite('Output\M64_Transect2_CrackWidth_UW.csv',table_crack_uw_2);
%% Import and process original data_JPL
% read data
Tran_or = csvread('VertexInput\Transect_Pnts_woTruncate.csv',1,0);
Tran_JPL_or = Tran_or;
TranwCrack_JPL_or = csvread('VertexInput\Transect_Pnts_wCrack_JPL_2_M6.4.csv',1,0);


% trancate data (for 2 measurement lines)
% Tran_1 is north one, line ID 5
Tran_jpl_1 = Tran_JPL_or(find(Tran_JPL_or(:,2) == 5):find(Tran_JPL_or(:,2) == 6)-1,:);
TranwCrack_jpl_1 = TranwCrack_JPL_or(find(TranwCrack_JPL_or(:,2) == 5):find(TranwCrack_JPL_or(:,2) == 6)-1,:);

% Tran_2 is the south one, line ID 4
Tran_jpl_2 = Tran_JPL_or(find(Tran_JPL_or(:,2) == 4):find(Tran_JPL_or(:,2) == 5)-1,:);
TranwCrack_jpl_2 = TranwCrack_JPL_or(find(TranwCrack_JPL_or(:,2) == 4):find(TranwCrack_JPL_or(:,2) == 5)-1,:);


%%%%%%%%% Line 1
% Calculate distance from the first pnts
TranwCrack_len_jpl_1 = pnts2Len(TranwCrack_jpl_1(:,4),TranwCrack_jpl_1(:,5));

% preallocate cumulative crack width
cum_width_jpl_1 = zeros(length(TranwCrack_len_jpl_1),1);

% set counter, initialization
i = 1; cum_width_i = 0;

% Preallocate matrix for crack width table
table_jpl_1 =[TranwCrack_jpl_1(:,4:5), nan(length(TranwCrack_len_jpl_1),1)];

% Calculate Cumulative Crack Width
while i <= length(TranwCrack_len_jpl_1)
    
    if ~ismember( TranwCrack_jpl_1(i,4),Tran_jpl_1(:,4) )
        cum_width_i = cum_width_i + ( TranwCrack_len_jpl_1(i+1) - TranwCrack_len_jpl_1(i) );
        cum_width_jpl_1(i+1:end) = cum_width_i;
        table_jpl_1(i,3) = TranwCrack_len_jpl_1(i+1) - TranwCrack_len_jpl_1(i);
        i = i + 2;
    else
        table_jpl_1(i,1:2) =  NaN;
        i = i + 1;
    end
    
end

table_crack_jpl_1 = table_jpl_1(~isnan(table_jpl_1(:,1)),:);

%%%%%%%%% Line 2
% Calculate distance from the first pnts
TranwCrack_len_jpl_2 = pnts2Len(TranwCrack_jpl_2(:,4),TranwCrack_jpl_2(:,5));

% Preallocate cumulative crack width
cum_width_jpl_2 = zeros(length(TranwCrack_len_jpl_2),1);

% set counter, initialization
i = 1; cum_width_i = 0;

% Preallocate matrix for crack width table
table_jpl_2 =[TranwCrack_jpl_2(:,4:5), nan(length(TranwCrack_len_jpl_2),1)];

% Calculate Cumulative Crack Width
while i <= length(TranwCrack_len_jpl_2)
    
    if ~ismember( TranwCrack_jpl_2(i,4),Tran_jpl_2(:,4) )
        cum_width_i = cum_width_i + ( TranwCrack_len_jpl_2(i+1) - TranwCrack_len_jpl_2(i) );
        cum_width_jpl_2(i+1:end) = cum_width_i;
        table_jpl_2(i,3) = TranwCrack_len_jpl_2(i+1) - TranwCrack_len_jpl_2(i);
        i = i + 2;
    else
        table_jpl_2(i,1:2) = NaN;
        i = i + 1;
    end
    
end

table_crack_jpl_2 = table_jpl_2(~isnan(table_jpl_2(:,1)),:);
%% plot
figure(1); subplot(2,1,1); grid on;hold on;
plot(TranwCrack_len_jpl_1,cum_width_jpl_1,'LineWidth',2);
set(gca,'FontSize',28,'YLim',[0,0.4])
text(0,0.4, 'JPL data','FontSize',20)
% title('Cumulative Crack Width Along Transect#1 M6.4 JPL')
xlabel('Horizontal Distance (m)')
ylabel('Cumulative Crack Width (m)')
title('Cumulative Crack Width Along Transect#1 M6.4')



figure(2); subplot(2,1,1); grid on;hold on;
plot(TranwCrack_len_jpl_2,cum_width_jpl_2,'LineWidth',2);
set(gca,'FontSize',28,'YLim',[0,0.6])
text(0,0.5, 'JPL data','FontSize',20)
% title('Cumulative Crack Width Along Transect#2 M6.4 JPL')
xlabel('Horizontal Distance (m)')
ylabel('Cumulative Crack Width (m)')
title('Cumulative Crack Width Along Transect#2 M6.4')

%% Write data to text files_JPL
% fileID = fopen('M64_CumulativeCrackWidth_JPL.txt','w');
% fprintf(fileID,'Note:The distance is measured from west to east. Unit for both distance and width are meter\n\n');
% fprintf(fileID,'%8s,    %18s\n','Distance','Cumulative Width');
% fprintf(fileID,'Line1(North)\n');
% fprintf(fileID,'%8.3f,    %18.3f\n',[TranwCrack_len_JPL_2; cum_width_JPL_2']);
% fprintf(fileID,'\n\nLine2(South)\n');
% fprintf(fileID,'%8.3f,    %18.3f\n',[TranwCrack_len_JPL_1; cum_width_JPL_1']);
% fclose(fileID);

% in excel instead
csvwrite('Output\M64_Transect1_CulmulativeWidth_JPL.csv',[TranwCrack_len_jpl_1', cum_width_jpl_1]);
csvwrite('Output\M64_Transect2_CulmulativeWidth_JPL.csv',[TranwCrack_len_jpl_2', cum_width_jpl_2]);

% Write crack position and corresponding width
csvwrite('Output\M64_Transect1_CrackWidth_JPL.csv',table_crack_jpl_1);
csvwrite('Output\M64_Transect2_CrackWidth_JPL.csv',table_crack_jpl_2);

%% Simple Function
function lens_array = pnts2Len(x_array, y_array)
    if length(x_array) ~= length(y_array)
        error('x y lengths differ')
    end
    lens_array = [0];
    dis = 0;
    for i  = 1:1:length(x_array)-1
        dis = dis + sqrt((x_array(i+1) - x_array(i)).^2 +  (y_array(i+1) - y_array(i)).^2 );
        lens_array = [lens_array, dis];
    end
end