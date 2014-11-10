function [] = draw_grid (level)

    hold on

    % horizontal
    for i = -36:4:-11
        plot3([-22 18],[i i],[level*2.5 level*2.5]);
    end

    % vertical
    for i = -22:4:18
        plot3([i i],[-36 -11],[level*2.5 level*2.5]);
    end

end