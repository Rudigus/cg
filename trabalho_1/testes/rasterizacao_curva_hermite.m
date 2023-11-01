% Arquivo de script
1;

%{
Entrada:
    - uma matriz 4x2 em que as duas primeiras linhas representam dois pontos de
      controle e últimas linhas representam dois vetores tangente,
      todos em coordenadas normalizadas.
    - uma resolução de tela / dispositivo.
Saída:
    - Uma matriz 2x2 em que cada linha representa um ponto em coordenadas
 do dispositivo.
%}
function curvaTela = curvaNormParaTela(curvaNormalizada, resolucao)
    curvaTela = zeros(4,2);
    for i = 1:4
        curvaTela(i,:) = pontoNormParaTela(curvaNormalizada(i,:), resolucao);
    end
end

function img = rasterizarCurva(curva, numPontos, img)
    pontos = zeros(numPontos,2);
    for i = 1:numPontos
        t = (i - 1) * (1 / (numPontos - 1));
        pontos(i,:) = [t^3 t^2 t 1] * [2 -2 1 1; -3 3 -2 -1; 0 0 1 0; 1 0 0 0] ...
                      * curva;
    end
    for i = 1:numPontos - 1
        reta = [pontos(i,:); pontos(i + 1,:)];
        img = rasterizarReta(reta, img);
    end
end

curvasNormalizadas = {[0.5 0.4; 0.9 0.8; 0.5 -1; 0.5 -1] [-0.5 0.6; 0.3 0.6; -0.5 1; 0.3 1] ...
                      [-0.8 0; -0.4 0; 2.2 -2; 0 1.5] [0.7 -0.8; 0.7 -0.8; -2 -0.2; 2 -0.2] ...
                      [0 0; 0.8 -0.4; -5.8 1.8; -3 -1]};
% Defina as resoluções desejadas
resolucoes = [100 100; 300 300; 800 600; 1920 1080];
% Loop através das diferentes resoluções
for i = 1:length(resolucoes)
    resolucao = resolucoes(i, :);
    % Crie uma matriz vazia para a imagem
    img = zeros(resolucao(1, 2), resolucao(1, 1));
    for j = 1:length(curvasNormalizadas)
        curvaTela = curvaNormParaTela(curvasNormalizadas{j}, resolucao);
        img = rasterizarCurva(curvaTela, 50, img);
    end
    % Mostre a imagem
    subplot(2, 2, i);
    imshow(img);
    title(sprintf('Resolução: %d x %d', resolucao));
end
