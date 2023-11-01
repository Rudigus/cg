% Arquivo de script
1;

function poligonoTela = poligonoNormParaTela(poligonoNormalizado, resolucao)
    numPontos = rows(poligonoNormalizado);
    poligonoTela = zeros(numPontos,2);
    for i = 1:numPontos
        poligonoTela(i,:) = pontoNormParaTela(poligonoNormalizado(i,:), resolucao);
    end
end

function img = rasterizarPoligono(poligono, img)
    numLinhasImg = rows(img);
    numColunasImg = columns(img);
    % É utilizado um canvas auxiliar para a pintura correta do polígono
    imgAux = zeros(numLinhasImg, numColunasImg);
    % Rasteriza as arestas do polígono
    numVertices = length(poligono);
    for i = 1:numVertices - 1
        reta = [poligono(i,:); poligono(i + 1,:)];
        imgAux = rasterizarReta(reta, imgAux);
    end
    retaFinal = [poligono(numVertices,:); poligono(1, :)];
    imgAux = rasterizarReta(retaFinal, imgAux);
    % Pinta o interior do polígono por meio de scanline
    for i = 1:numLinhasImg
        numIntersecoes = 0;
        for j = 1:numColunasImg-1
            % A interseção é contada logo antes de entrar no interior do polígono
            if imgAux(i, j) == 1 && imgAux(i, j + 1) != 1
                if mod(numIntersecoes, 2) == 1
                    numIntersecoes += 1;
                    continue;
                else
                    % Checa se existe aresta no restante das colunas para
                    % evitar a contagem de um vértice indevido
                    for k = j+2:numColunasImg
                        if imgAux(i, k) == 1
                            numIntersecoes += 1;
                            break;
                        end
                    end
                end
            end
            % Efetivamente pinta o interior do polígono
            if mod(numIntersecoes, 2) == 1
                imgAux(i, j) = 1;
            end
        end
    end
    % Insere o polígono no canvas principal
    img = bitor(img, imgAux);
end

poligonosNormalizados = ...
{[0.3 0.9; 0.6 (0.9 - 0.3 * sqrt(3)); 0.9 0.9] [-0.9 -0.9; -0.9 -0.6; (-0.9 + 0.15 * sqrt(3)) -0.75] ...
[0.6 0.0; 0.6 0.2; 0.8 0.2; 0.8 0.0] [-0.7 0.9; -0.7 0.6; -0.4 0.6; -0.4 0.9] ...
[-0.2 -0.1; 0.2 -0.1; 0.4 (-0.1 + 0.2 * sqrt(3)); 0.2 (-0.1 + 0.4 * sqrt(3));
-0.2 (-0.1 + 0.4 * sqrt(3)); -0.4 (-0.1 + 0.2 * sqrt(3))] ...
[0.5 -0.1; 0.6 -0.1; 0.8 -0.65; 0.75 -0.85; 0.5 -0.9; 0.4 -0.7]};
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
