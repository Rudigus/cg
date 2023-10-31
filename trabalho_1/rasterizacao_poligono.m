% Arquivo de script
1;

function poligonoTela = poligonoNormParaTela(poligonoNormalizado, resolucao)
    poligonoTela = zeros(4,2);
    for i = 1:4
        poligonoTela(i,:) = pontoNormParaTela(poligonoNormalizado(i,:), resolucao);
    end
end

function img = rasterizarPoligono(poligono, img)
    % Rasterizar as arestas do polígono
    numVertices = length(poligono);
    for i = 1:numVertices - 1
        reta = [poligono(i,:); poligono(i + 1,:)];
        img = rasterizarReta(reta, img);
    end
    retaFinal = [poligono(numVertices,:); poligono(1, :)];
    img = rasterizarReta(retaFinal, img);
    % Pintar o interior do polígono por meio de scanline
    numLinhas = rows(img);
    numColunas = columns(img);
    for i = 1:numLinhas
        numIntersecoes = 0;
        for j = 1:numColunas-1
            % A interseção é contada logo antes de entrar no interior do polígono
            if img(i, j) == 1 && img(i, j + 1) != 1
                if mod(numIntersecoes, 2) == 1
                    numIntersecoes += 1;
                    continue;
                else
                    % Checa se existe aresta no restante das colunas para
                    % evitar a contagem de um vértice indevido
                    for k = j+2:numColunas
                        if img(i, k) == 1
                            numIntersecoes += 1;
                            break;
                        end
                    end
                end
            end
            % Efetivamente pinta o interior do polígono
            if mod(numIntersecoes, 2) == 1
                img(i, j) = 1;
            end
        end
    end
end

poligonosNormalizados = {[0.0 0.0; 0.2 0.2; 0.4 0.0; 0.2 -0.2]};
%{[0.0 0.0; 0.2 0.2; 0.4 0.0; 0.2 -0.2], [0.6 0.0; 0.6 0.2; 0.8 0.2; 0.8 0.0]};
% Defina as resoluções desejadas
resolucoes = [100 100; 300 300; 800 600; 1920 1080];
% Loop através das diferentes resoluções
for i = 1:length(resolucoes)
    resolucao = resolucoes(i, :);
    % Crie uma matriz vazia para a imagem
    img = zeros(resolucao(1, 2), resolucao(1, 1));
    for j = 1:length(poligonosNormalizados)
        poligonoTela = poligonoNormParaTela(poligonosNormalizados{j}, resolucao);
        img = rasterizarPoligono(poligonoTela, img);
    end
    % Mostre a imagem
    subplot(2, 2, i);
    imshow(img);
    title(sprintf('Resolução: %d x %d', resolucao));
end
