% FarleyPatrick_Final_Project_Genetics.m:  Plots the genetic changes in a
% population over time when there are external pressures. Two major traits:
% color (no advantage), size (a disadvantage)
% Created 10-14-12 by Patrick Farley
%
clear;
%% Create an active population:
%
% Starting population:
for i_liz = 1:10
    liz(i_liz,1) = i_liz; % identification number
    liz(i_liz,2) = (rand*54 + 12); % age (months)
    liz(i_liz,3) = (rand*16); % time since mated (months)
    liz(i_liz,4) = rand*5 + 11; % size
    liz(i_liz,5:7) = [0, rand*.5 + .5,rand*.5 + .5]; % genes for color
    if i_liz > 5 % shape (indicating male or female)
        liz(i_liz,8) = 's'; % male
    else
        liz(i_liz,8) = '^'; % female
    end
end
%
%
%% Parameter Variables:
grass(1) = 1000; % starting food for population
growth = 200; % minimum possible growth rate of food (amount per month)
tf = 12*500; % number of months over which to run the simulation
plot_every = 12; % number of months in between data plots
%
% NOTE: There is a chance that the population sometimes "dies out" during the
% simulation. This is due in part to the random factors in the simulation.
% Changing the variables "grass" and "growth" affects the likelihood of dying out
%
%% Other Necessary Variables:
liz_males = []; % a list of the male animals, which will be filled later
liz_count(1) = size(liz,1); % a list of the number of animals alive at each time interval
history = size(liz,1); % a counter of each animal that has ever been alive
t = 0; % time elapsed
count = 1; % a counter which refers to the nth time data is taken
%
%
%% Model population changes over time:
while t <= tf;
    % food grows each month (with some random variation):
    if count ~= 1
        grass(count) = grass(count-1) + growth + round(rand*(growth/8));
    end
    % food maxes out at original amount:
    if grass(count) > grass(1)
        grass(count) = grass(1);
    end
    
    % The following actions done with each member of the population:
    for i_liz = size(liz,1):-1:1
        %
        % each animal consumes food according to its size:
        grass(count) = grass(count)-round(liz(i_liz,4));
        %
        % grass does not go into negative amounts:
        if grass(count) < 0
            grass(count) = 0;
        end
        %
        % female animals reproduce if they are old enough and have not
        % reproduced in one year:
        if liz(i_liz,3) > 7 & liz(i_liz,2) > 12 & liz(i_liz,8) == 94
            %
            % pick a male to mate with:
            liz_males(:,:) = [];
            male = [];
            for i_liz_males = size(liz,1):-1:1
                if liz(i_liz_males,8) == 115
                    % add all males to the liz_males list:
                    liz_males(end+1,:) = liz(i_liz_males,:);
                end
            end
            
            if size(liz_males,1) >= 1
                % pick a random male from the list:
                male = liz_males(ceil(rand*size(liz_males,1)),:);
                
                % reset "time since mated" counter for female:
                liz(i_liz,3) = 0;
                
                % Create the offspring:
                history = history +1;
                liz(end+1,1:3) = [history,0,0];
                
                % size:
                liz(end,4) = (liz(i_liz,4) + male(4)) / 2 + .2*rand*...
                    ((liz(i_liz,4) + male(4)) / 2) - .2*rand*...
                    ((liz(i_liz,4) + male(4)) / 2);
                
                % random gender
                if rand < 0.5
                    liz(end,8) = 's';
                else
                    liz(end,8) = '^';
                end
                
                % Coloring: offspring recieves genes from parent(s), with
                % some random variation:
                % red:
                if rand < .33
                    liz(end,5) = liz(i_liz,5);
                elseif rand < .5
                    liz(end,5) = male(5);
                else
                    liz(end,5) = .5*liz(i_liz,5) + .5*male(5);
                end
                
                % green:
                if rand < .33
                    liz(end,6) = liz(i_liz,6);
                elseif rand < .5
                    liz(end,6) = male(6);
                else
                    liz(end,6) = .5*liz(i_liz,6) + .5*male(6);
                end
                
                % blue:
                if rand < .33
                    liz(end,7) = liz(i_liz,7);
                elseif rand < .5
                    liz(end,7) = male(7);
                else
                    liz(end,7) = .5*liz(i_liz,7) + .5*male(7);
                end
                % opportunity for random color variation (gene mutation):
                if rand < 0.25
                    liz(end,5) = (liz(end,5) + rand) / 2;
                    liz(end,6) = (liz(end,6) + rand) / 2;
                    liz(end,7) = (liz(end,7) + rand) / 2;
                end
            end
            
            
        end
        
        liz_count(count) = size(liz,1);
        
        % if there is not enough grass, animals die:
        % after 84 months (7 years) of life, animals die:
        if grass(count) < (liz(i_liz,4))^1.2% - (liz(i_liz,4))
            liz(i_liz,:) = [];
        elseif liz(i_liz,2) > 84
            liz(i_liz,:) = [];
        end
        if size(liz,1) == 0
            disp(['the population has died out after ',num2str(t/12), ' years'])
            break
        end
    end
    
    % advance animals' ages:
    liz(:,2) = liz(:,2) + 1;
    liz(:,3) = liz(:,3) + 1;
    
    % update population count:
    liz_count(count) = size(liz,1);
    
    
    %% Plot Population:
    if t / plot_every == round(t / plot_every)
        for i_liz = liz_count(count):-1:1
            set(gca,'YDir','reverse');
            plot(liz(i_liz,1),t,char(liz(i_liz,8)),'markerfacecolor',...
                [liz(i_liz,5) liz(i_liz,6) liz(i_liz,7)],...
                'markersize',liz(i_liz,4))
            xlabel('Nth Individual to appear in Population'),...
                ylabel('Time (months)'), title('Population Changes Over Time'),
            set(gca,'fontsize',19)
            h_xlabel = get(gca,'XLabel');
            set(h_xlabel,'FontSize',19);
            h_ylabel = get(gca,'YLabel');
            set(h_ylabel,'FontSize',19);
            hold on
        end
    end
    
    %% advance time and update population counter:
    t = t+1;
    count = count+1;
end
hold off

