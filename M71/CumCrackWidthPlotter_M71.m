clear all; close all; clc
%% Import and process original data_JPL
% read data
Tran_or = csvread('VertexInput\Transect_Pnts.csv',1,0);
TranwCrack_jpl_or = csvread('VertexInput\Transect_Pnts_wCrack_JPL_2.csv',1,0);


% trancate data (for 2 measurement lines)
Tran_jpl_1 = Tran_or(find(Tran_or(:,2) == 6):find(Tran_or(:,2) == 7)-1,:);
TranwCrack_jpl_1 = TranwCrack_jpl_or(find(TranwCrack_jpl_or(:,2) == 6):find(TranwCrack_jpl_or(:,2) == 7)-1,:);

Tran_jpl_2 = Tran_or(find(Tran_or(:,2) == 7):end,:);
TranwCrack_jpl_2 = TranwCrack_jpl_or(find(TranwCrack_jpl_or(:,2) == 7):end,:);

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
        table_jpl_1(i,1:2) = NaN;
        i = i + 1;
    end
    
end

table_jpl_crack_1 = table_jpl_1(~isnan(table_jpl_1(:,1)),:);


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

table_jpl_crack_2 = table_jpl_2(~isnan(table_jpl_2(:,1)),:);
%% plot
figure(1); subplot(2,1,1); grid on;hold on;
plot(TranwCrack_len_jpl_1,cum_width_jpl_1,'LineWidth',2);
set(gca,'FontSize',28,'YMinorTick','on')
ylim([0 1])
title('Cumulative Crack Width Along Transect#1 M7.1')
text(0,1, 'JPL data','FontSize',20)

% title('Cumulative Crack Width Along Transect#1 M7.1 JPL')
% xlabel('Horizontal Distance (m)')
% ylabel('Cumulative Crack Width (m)')


figure(2); subplot(2,1,1); grid on;hold on;
plot(TranwCrack_len_jpl_2,cum_width_jpl_2,'LineWidth',2);
ylim([0 1])
set(gca,'FontSize',28,'YMinorTick','on')
title('Cumulative Crack Width Along Transect#2 M7.1')
text(0,0.5, 'JPL data','FontSize',20)
% title('Cumulative Crack Width Along Transect#2 M7.1 JPL')
% xlabel('Horizontal Distance (m)')
% ylabel('Cumulative Crack Width (m)')

%% Write data to text files_JPL

% write culmulative width vs distance in txt files
% fileID = fopen('M71_CumulativeCrackWidth_JPL.txt','w');
% fprintf(fileID,'Note:The distance is measured from west to east. Unit for both distance and width are meter\n\n');
% fprintf(fileID,'%8s,    %18s\n','Distance','Cumulative Width');
% fprintf(fileID,'Line1(North)\n');
% fprintf(fileID,'%8.3f,    %18.3f\n',[TranwCrack_len_jpl_1; cum_width_jpl_1']);
% fprintf(fileID,'\n\nLine2(South)\n');
% fprintf(fileID,'%8.3f,    %18.3f\n',[TranwCrack_len_jpl_2; cum_width_jpl_2']);
% fclose(fileID);

% Write culmulative width vs distance in txt files in excel files
csvwrite('Output\M71_Transect1_CulmulativeWidth_JPL.csv',[TranwCrack_len_jpl_1', cum_width_jpl_1]);
csvwrite('Output\M71_Transect2_CulmulativeWidth_JPL.csv',[TranwCrack_len_jpl_2', cum_width_jpl_2]);

% Write crack position and corresponding width
csvwrite('Output\M71_Transect1_CrackWidth_JPL.csv',table_jpl_crack_1);
csvwrite('Output\M71_Transect2_CrackWidth_JPL.csv',table_jpl_crack_2);
%% Import and process original data_UCLA
% read data
Tran_UCLA_or = csvread('VertexInput\Transect_Pnts.csv',1,0);
TranwCrack_UCLA_or = csvread('VertexInput\Transect_Pnts_wCrack_UCLA_2.csv',1,0);


% trancate data (for 2 measurement lines)
Tran_UCLA_1 = Tran_UCLA_or(find(Tran_UCLA_or(:,2) == 6):find(Tran_UCLA_or(:,2) == 7)-1,:);
TranwCrack_UCLA_1 = TranwCrack_UCLA_or(find(TranwCrack_UCLA_or(:,2) == 6):find(TranwCrack_UCLA_or(:,2) == 7)-1,:);

Tran_UCLA_2 = Tran_UCLA_or(find(Tran_UCLA_or(:,2) == 7):end,:);
TranwCrack_UCLA_2 = TranwCrack_UCLA_or(find(TranwCrack_UCLA_or(:,2) == 7):end,:);

%%%%%%%%% Line 1
% Calculate distance from the first pnts
TranwCrack_len_UCLA_1 = pnts2Len(TranwCrack_UCLA_1(:,4),TranwCrack_UCLA_1(:,5));

% preallocate cumulative crack width
cum_width_UCLA_1 = zeros(length(TranwCrack_len_UCLA_1),1);

% set counter, initialization
i = 1; cum_width_i = 0;

% Preallocate matrix for crack width table
table_ucla_1 =[TranwCrack_UCLA_1(:,4:5), nan(length(TranwCrack_len_UCLA_1),1)];

% Calculate Cumulative Crack Width
while i <= length(TranwCrack_len_UCLA_1)
    
    if ~ismember( TranwCrack_UCLA_1(i,4),Tran_UCLA_1(:,4) )
        cum_width_i = cum_width_i + ( TranwCrack_len_UCLA_1(i+1) - TranwCrack_len_UCLA_1(i) );
        cum_width_UCLA_1(i+1:end) = cum_width_i;
        table_ucla_1(i,3) = TranwCrack_len_UCLA_1(i+1) - TranwCrack_len_UCLA_1(i);
        i = i + 2;
    else
        table_ucla_1(i,1:2) = NaN;
        i = i + 1;
    end
    
end

table_ucla_crack_1 = table_ucla_1(~isnan(table_ucla_1(:,1)),:);
%%%%%%%%% Line 2
% Calculate distance from the first pnts
TranwCrack_len_UCLA_2 = pnts2Len(TranwCrack_UCLA_2(:,4),TranwCrack_UCLA_2(:,5));

% Preallocate cumulative crack width
cum_width_UCLA_2 = zeros(length(TranwCrack_len_UCLA_2),1);

% set counter, initialization
i = 1; cum_width_i = 0;

% Preallocate matrix for crack width table
table_ucla_2 =[TranwCrack_UCLA_2(:,4:5), nan(length(TranwCrack_len_UCLA_2),1)];

% Calculate Cumulative Crack Width
while i <= length(TranwCrack_len_UCLA_2)
    
    if ~ismember( TranwCrack_UCLA_2(i,4),Tran_UCLA_2(:,4) )
        cum_width_i = cum_width_i + ( TranwCrack_len_UCLA_2(i+1) - TranwCrack_len_UCLA_2(i) );
        cum_width_UCLA_2(i+1:end) = cum_width_i;
        table_ucla_2(i,3) = TranwCrack_len_UCLA_2(i+1) - TranwCrack_len_UCLA_2(i);
        i = i + 2;
    else
        table_ucla_2(i,1:2) = NaN;
        i = i + 1;
    end
    
end

table_ucla_crack_2 = table_ucla_2(~isnan(table_ucla_2(:,1)),:);
%% plot
figure(1); subplot(2,1,2); grid on;hold on;
plot(TranwCrack_len_UCLA_1,cum_width_UCLA_1,'LineWidth',2);
set(gca,'FontSize',28,'YMinorTick','on')
ylim([0 1])
text(0,1, 'UCLA data','FontSize',20)
% title('Cumulative Crack Width Along Transect#1 M7.1 UCLA')
xlabel('Horizontal Distance (m)')
ylabel('Cumulative Crack Width (m)')


figure(2); subplot(2,1,2); grid on;hold on;
plot(TranwCrack_len_UCLA_2,cum_width_UCLA_2,'LineWidth',2);
set(gca,'FontSize',28,'YMinorTick','on')
ylim([0 1])
text(0,2, 'UCLA data','FontSize',20)
% title('Cumulative Crack Width Along Transect#2 M7.1 UCLA')
xlabel('Horizontal Distance (m)')
ylabel('Cumulative Crack Width (m)')

%% Write data to text files_UCLA
% fileID = fopen('M71_CumulativeCrackWidth_UCLA.txt','w');
% fprintf(fileID,'Note:The distance is measured from west to east. Unit for both distance and width are meter\n\n');
% fprintf(fileID,'%8s,    %18s\n','Distance','Cumulative Width');
% fprintf(fileID,'Line1(North)\n');
% fprintf(fileID,'%8.3f,    %18.3f\n',[TranwCrack_len_UCLA_1; cum_width_UCLA_1']);
% fprintf(fileID,'\n\nLine2(South)\n');
% fprintf(fileID,'%8.3f,    %18.3f\n',[TranwCrack_len_UCLA_2; cum_width_UCLA_2']);
% fclose(fileID);

% in excel instead
csvwrite('Output\M71_Transect1_CulmulativeWidth_UCLA.csv',[TranwCrack_len_UCLA_1', cum_width_UCLA_1]);
csvwrite('Output\M71_Transect2_CulmulativeWidth_UCLA.csv',[TranwCrack_len_UCLA_2', cum_width_UCLA_2]);
% Write crack position and corresponding width

csvwrite('Output\M71_Transect1_CrackWidth_UCLA.csv',table_ucla_crack_1);
csvwrite('Output\M71_Transect2_CrackWidth_UCLA.csv',table_ucla_crack_2);
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