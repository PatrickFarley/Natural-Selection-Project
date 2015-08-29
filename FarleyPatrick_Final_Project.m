% FarleyPatrick_Final_Project.m:  Plots the changes in a population over
% time when there are limited resources to sustain it.
% Created 10-14-12 by Patrick Farley
%
%% Option to run simulation multiple times on one plot:
turn = 1;

while turn <= 1
    clearvars -except turn;
    %% Create an active population:
    %
    % Starting population:
    for i_liz = 1:20
        liz(i_liz,1) = i_liz % number
        liz(i_liz,2) = (rand*54 + 12) % age (months)
        liz(i_liz,3) = (rand*16) % time since mated (months)
    end
    %
    % Initial number of animals:
    animal_count(1) = size(liz,1);
    %% Starting food for population:
    grass(1) = 3000;
    %% Model population changes over time
    t = 0;
    count = 1
    while t < 12*20;
        % grass grows each month:
        if count ~=1
            grass(count) = grass(count-1) + 500 + round(rand*100);
        end
        % grass maxes out:
        if grass(count) > 3000
            grass(count) = 3000;
        end
        for i_liz = size(liz,1):-1:1
            % each animal eats grass
            grass(count) = grass(count)-5;
            % animals might reproduce if they are old enough and have not
            % reproduced in one year:
            if liz(i_liz,3) > 12 & liz(i_liz,2) > 12 & rand > 0.25
                liz(i_liz,3) = 0;
                liz(end+1,:) = [animal_count(count)+1,0,0];
                
            end
            % if there is no grass, animals die. After 84 months (7 years),
            % animals are increasingly more likely to die:
            if grass(count) < 5
                liz(i_liz,:) = [];
            elseif liz(i_liz,2) > 84 & rand*liz(i_liz,2) > 60
                liz(i_liz,:) = [];
            end
            
            % grass does not go into negative amounts:
            if grass(count) < 0
                grass(count) = 0;
            end
        end
        % advance animals' ages:
        liz(:,2) = liz(:,2) + 1;
        liz(:,3) = liz(:,3) + 1;
        % advance time and update counter:
        t = t+1;
        count = count+1;
        animal_count(count) = size(liz,1);
    end
    
    %% Plot Population vs Time:
    figure(1)
    subplot(211)
    plot(0:t,animal_count, '-','color',[.5 .1 .1]),
    xlabel('Time (months)'), ylabel('Population number'), title('Population')
     set(gca,'fontsize',19)
            h_xlabel = get(gca,'XLabel');
            set(h_xlabel,'FontSize',19);
            h_ylabel = get(gca,'YLabel');
            set(h_ylabel,'FontSize',19);
    hold on
    %% Plot Food vs Time:
    subplot(212)
    plot(0:t-1,grass, '-','color',[0 .7 0]),
    xlabel('Time (months)'), ylabel('Food amount'), title('Food')
    hold on
     set(gca,'fontsize',19)
            h_xlabel = get(gca,'XLabel');
            set(h_xlabel,'FontSize',19);
            h_ylabel = get(gca,'YLabel');
            set(h_ylabel,'FontSize',19);
    turn = turn+1;
end

hold off