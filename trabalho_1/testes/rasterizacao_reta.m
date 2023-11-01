% Arquivo de script
1;

%{
Entrada:
    - uma matriz 2x2 em que cada linha representa um ponto em coordenadas
      normalizadas.
    - uma resolução de tela / dispositivo.
Saída:
    - Uma matriz 2x2 em que cada linha representa um ponto em coordenadas
 do dispositivo.
%}
function retaTela = retaNormParaTela(retaNormalizada, resolucao)
    retaTela = zeros(2,2);
    for i = 1:2
        retaTela(i,:) = pontoNormParaTela(retaNormalizada(i,:), resolucao);
    end
end

% Define as coordenadas dos pontos iniciais e finais dos segmentos de reta
% intervalo normalizado: ambos x e y estão no intervalo de -1 a 1
retasNormalizadas = {[-0.5 -0.5; -0.5 0] [0.4 0.3; 0.2 0] [-0.5 -0.7; 0.5 -0.7] ...
                     [-0.8 0.7; 0.8 0.9] [-0.8 0.6; 0.7 -0.6]};
% Defina as resoluções desejadas
resolucoes = [100 100; 300 300; 800 600; 1920 1080];
% Loop através das diferentes resoluções
for i = 1:length(resolucoes)
    resolucao = resolucoes(i, :);
    % Crie uma matriz vazia para a imagem
    img = zeros(resolucao(1, 2), resolucao(1, 1));
    for j = 1:length(retasNormalizadas)
        retaTela = retaNormParaTela(retasNormalizadas{j}, resolucao);
        img = rasterizarReta(retaTela, img);
    end
    % Mostre a imagem
    subplot(2, 2, i);
    imshow(img);
    title(sprintf('Resolução: %d x %d', resolucao));
end
