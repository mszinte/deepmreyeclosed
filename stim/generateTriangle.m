function triangleCoords = generateTriangle(scrSizeX, scrSizeY)
    % Calculate the center of the screen
    centerX = scrSizeX / 2;
    centerY = scrSizeY / 2;

    % Define the size of the triangle 
    triangleSize = min(scrSizeX, scrSizeY) / 1.25;

    % Calculate the coordinates of the vertices
    x1 = centerX;
    y1 = centerY - triangleSize / sqrt(3);

    x2 = centerX - triangleSize / 2;
    y2 = centerY + triangleSize / (2 * sqrt(3));

    x3 = centerX + triangleSize / 2;
    y3 = y2;

    % Create the matrix of triangle coordinates
    triangleCoords = [x1, y1; x2, y2; x3, y3; x1, y1];
end



