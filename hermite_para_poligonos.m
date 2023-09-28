function polygon_rasterization_demo()
    % Exemplo 1: Triângulo equilátero
    triangle_vertices = [1, 1; 3, 1; 2, 3];
    resolutions = [0.1, 0.05, 0.02, 0.01];
    
    figure;
    subplot(2, 2, 1);
    rasterize_polygon(triangle_vertices, resolutions(1), 'Triângulo (0.1 res.)');
    subplot(2, 2, 2);
    rasterize_polygon(triangle_vertices, resolutions(2), 'Triângulo (0.05 res.)');
    subplot(2, 2, 3);
    rasterize_polygon(triangle_vertices, resolutions(3), 'Triângulo (0.02 res.)');
    subplot(2, 2, 4);
    rasterize_polygon(triangle_vertices, resolutions(4), 'Triângulo (0.01 res.)');
    
    % Exemplo 2: Quadrado
    square_vertices = [1, 1; 3, 1; 3, 3; 1, 3];
    
    figure;
    subplot(2, 2, 1);
    rasterize_polygon(square_vertices, resolutions(1), 'Quadrado (0.1 res.)');
    subplot(2, 2, 2);
    rasterize_polygon(square_vertices, resolutions(2), 'Quadrado (0.05 res.)');
    subplot(2, 2, 3);
    rasterize_polygon(square_vertices, resolutions(3), 'Quadrado (0.02 res.)');
    subplot(2, 2, 4);
    rasterize_polygon(square_vertices, resolutions(4), 'Quadrado (0.01 res.)');
    
    % Exemplo 3: Hexágono
    hexagon_vertices = [2, 1; 1, 2; 2, 3; 4, 3; 5, 2; 4, 1];
    
    figure;
    subplot(2, 2, 1);
    rasterize_polygon(hexagon_vertices, resolutions(1), 'Hexágono (0.1 res.)');
    subplot(2, 2, 2);
    rasterize_polygon(hexagon_vertices, resolutions(2), 'Hexágono (0.05 res.)');
    subplot(2, 2, 3);
    rasterize_polygon(hexagon_vertices, resolutions(3), 'Hexágono (0.02 res.)');
    subplot(2, 2, 4);
    rasterize_polygon(hexagon_vertices, resolutions(4), 'Hexágono (0.01 res.)');
end

function rasterize_polygon(vertices, resolution, title_str)
    min_x = min(vertices(:, 1));
    max_x = max(vertices(:, 1));
    min_y = min(vertices(:, 2));
    max_y = max(vertices(:, 2));
    
    [X, Y] = meshgrid(min_x:resolution:max_x, min_y:resolution:max_y);
    [rows, cols] = size(X);
    
    in_polygon = inpolygon(X(:), Y(:), vertices(:, 1), vertices(:, 2));
    
    X(~in_polygon) = NaN;
    Y(~in_polygon) = NaN;
    
    scatter(X(:), Y(:), 10, 'r', 'filled');
    axis([min_x - 1, max_x + 1, min_y - 1, max_y + 1]);
    title(title_str);
    grid on;
    axis equal;
end

% Chamar a função de demonstração
polygon_rasterization_demo();
