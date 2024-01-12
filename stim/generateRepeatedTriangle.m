function const = generateRepeatedTriangle(const, scr, dur, customTriangleCoords)
    % Generate repeated triangle coordinates in a specified window
    % on a screen. Coordinates are repeated based on const.triang_rot.
    % SK, Dec 23

    % Number of locations
    n_rep = const.triang.n_rep;
   
    % Repeat triangle coordinates
    triang_xy = repmat(customTriangleCoords, n_rep, 1);

    % Split into frames and trials
    fix_dur = round(dur * scr.hz);
    const.triang.xy_trials_triang = arrayfun(@(i) repmat(triang_xy(i,:), fix_dur, 1), 1:length(triang_xy), 'uni', 0);

  

    % Display scatter plot of generated coordinates
    %figure;
    %hold on;

    % Flatten the cell array into a single matrix
    %flatCoords = cell2mat(const.triang.xy_trials_triang);

    % Scatter plot of flattened coordinates
    %scatter(flatCoords(:, 1), flatCoords(:, 2));

    %hold off;

    %title('Flattened Scatter Plot of Generated Coordinates');
    %xlabel('X-coordinate');
    %ylabel('Y-coordinate');
end
