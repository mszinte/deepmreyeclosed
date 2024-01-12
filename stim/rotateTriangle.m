function rotatedTriangle = rotateTriangle(triangleCoords)
    % Calculate the center of the triangle
    center = mean(triangleCoords);

    % Translate the triangle to the origin
    translatedTriangle = triangleCoords - center;

    % Define the rotation matrix for a 90-degree rotation
    rotationMatrix = [0 -1; 1 0];

    % Rotate the translated triangle
    rotatedTriangle = (rotationMatrix * translatedTriangle')';

    % Translate the rotated triangle back to its original position
    rotatedTriangle = rotatedTriangle + center;

    % Display the rotated coordinates
    disp('Rotated Triangle Coordinates:');
    disp(rotatedTriangle);
end
