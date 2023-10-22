%{
Entrada:
    - uma matriz 2x2 em que cada linha representa um ponto em coordenadas
      do dispositivo
    - uma resolução de tela / dispositivo.
    - Uma matriz de pixels vazia ou já preenchida com rasterizações anteriores
Saída:
    - Uma matriz de pixels preenchida com a rasterização da reta de entrada
%}
function img = rasterizarReta(reta, img)
    x1 = reta(1, 1);
    y1 = reta(1, 2);
    x2 = reta(2, 1);
    y2 = reta(2, 2);

    % Calcule os deltas das coordenadas x e y
    dx = x2 - x1;
    dy = y2 - y1;
    if (abs(dx) > abs(dy))
        if (x1 > x2)
            [x1, x2] = deal(x2, x1);
            [y1, y2] = deal(y2, y1);
        end
        x = x1;
        y = y1;
        m = dy / dx;
        b = y1 - m * x1;

        % Rasterize o segmento de reta
        [xp, yp] = produzFragmento(x, y);
        img(yp, xp) = 1;
        while (x < x2)
            x = x + 1;
            y = m * x + b;
            [xp, yp] = produzFragmento(x, y);
            img(yp, xp) = 1;
        end
    else
        if (y1 > y2)
            [x1, x2] = deal(x2, x1);
            [y1, y2] = deal(y2, y1);
        end
        x = x1;
        y = y1;
        m = dx / dy;
        b = x1 - m * y1;

        % Rasterize o segmento de reta
        [xp, yp] = produzFragmento(x, y);
        img(yp, xp) = 1;
        while (y < y2)
            y = y + 1;
            x = m * y + b;
            [xp, yp] = produzFragmento(x, y);
            img(yp, xp) = 1;
        end
    end
end

function [xp, yp] = produzFragmento(x,y)
    % Epsilon (eps) é utilizado para prevenir erros de ponto flutuante
    xm = floor(x + eps(1e4));
    ym = floor(y + eps(1e4));
    xp = xm + 1;
    yp = ym + 1;
end
