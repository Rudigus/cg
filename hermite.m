function hermite_curve_demo()
    % Exemplo 1: Curva de Hermite com P1 e P2 diferentes
    P0 = [0, 0];
    P1 = [1, 2];
    P2 = [3, 3];
    P3 = [4, 0];
    num_segments = 100;
    
    figure;
    rasterize_hermite_curve(P0, P1, P2, P3, num_segments);
    title('Curva de Hermite com P1 e P2 diferentes');

    % Exemplo 2: Curva de Hermite com P1 e P2 iguais
    P0 = [0, 0];
    P1 = [1, 2];
    P2 = [1, 2];
    P3 = [4, 0];
    
    figure;
    rasterize_hermite_curve(P0, P1, P2, P3, num_segments);
    title('Curva de Hermite com P1 e P2 iguais');
    
    % Exemplo 3: Curva de Hermite com diferentes números de segmentos
    P0 = [0, 0];
    P1 = [1, 2];
    P2 = [3, 3];
    P3 = [4, 0];
    num_segments_1 = 10;
    num_segments_2 = 50;
    num_segments_3 = 200;

    figure;
    subplot(1, 3, 1);
    rasterize_hermite_curve(P0, P1, P2, P3, num_segments_1);
    title('10 Segmentos');

    subplot(1, 3, 2);
    rasterize_hermite_curve(P0, P1, P2, P3, num_segments_2);
    title('50 Segmentos');

    subplot(1, 3, 3);
    rasterize_hermite_curve(P0, P1, P2, P3, num_segments_3);
    title('200 Segmentos');
end

function rasterize_hermite_curve(P0, P1, P2, P3, num_segments)
    t_values = linspace(0, 1, num_segments);
    x_values = zeros(1, num_segments);
    y_values = zeros(1, num_segments);

    for i = 1:num_segments
        t = t_values(i);
        [x, y] = hermite_curve(P0, P1, P2, P3, t);
        x_values(i) = x;
        y_values(i) = y;
    end

    plot(x_values, y_values, 'ro-');
    axis equal;
    grid on;
end

function [x, y] = hermite_curve(P0, P1, P2, P3, t)
    % Coeficientes do polinômio de Hermite
    H0 = 2*t^3 - 3*t^2 + 1;
    H1 = -2*t^3 + 3*t^2;
    H2 = t^3 - 2*t^2 + t;
    H3 = t^3 - t^2;

    % Calcular as coordenadas x e y da curva
    x = H0*P0(1) + H1*P1(1) + H2*P2(1) + H3*P3(1);
    y = H0*P0(2) + H1*P1(2) + H2*P2(2) + H3*P3(2);
end

% Chamar a função de demonstração
hermite_curve_demo();
