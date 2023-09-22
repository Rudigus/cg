% Arquivo de script
1;

%{
Entrada:
    - uma matriz 2x2 em que cada linha representa um ponto em coordenadas
      normalizadas
    - uma resolução de tela / dispositivo.
Saída:
    - Uma matriz 2x2 em que cada linha representa um ponto em coordenadas
 do dispositivo.
%}
function retaTela = normParaTela(retaNormalizada, resolucao)
    larguraTela = resolucao(1, 1);
    alturaTela = resolucao(1, 2);
    retaTela = zeros(2,2);
    for j = 1:2
        retaTela(j,1) = larguraTela * (-1 - retaNormalizada(j,1)) / -2;
        retaTela(j,2) = alturaTela * (-1 - retaNormalizada(j,2)) / -2;
    end
end

%{
Entrada:
    - uma matriz 2x2 em que cada linha representa um ponto em coordenadas
      do dispositivo
    - uma resolução de tela / dispositivo.
    - Uma matriz de pixels vazia ou já preenchida com rasterizações anteriores
Saída:
    - Uma matriz de pixels preenchida com a rasterização da reta de entrada
%}
function img = rasterizarReta(reta, resolucao, img)
    x1 = reta(1, 1);
    y1 = reta(1, 2);
    x2 = reta(2, 1);
    y2 = reta(2, 2);
    larguraTela = resolucao(1, 1);
    alturaTela = resolucao(1, 2);

    % Calcule os deltas das coordenadas x e y
    dx = (x2 - x1) / larguraTela;
    dy = (y2 - y1) / alturaTela;

    % Calcule os valores de x e y iniciais
    x = x1;
    y = y1;

    % Rasterize o segmento de reta
    for j = 1:larguraTela
        % Arredonde os valores de x e y para os índices da matriz
        x_index = round(x);
        y_index = round(y);

        % Verifique se o índice está dentro dos limites da matriz
        if x_index >= 1 && x_index <= larguraTela && y_index >= 1 && y_index <= alturaTela
            img(y_index, x_index) = 1; % Defina o pixel como branco
        end

        % Atualize os valores de x e y
        x = x + dx;
        y = y + dy;
    end
end

% Define as coordenadas dos pontos iniciais e finais dos segmentos de reta
% intervalo normalizado: ambos x e y estão no intervalo de -1 a 1
retasNormalizadas = {[-0.5 -0.5; -0.5 0.5] [0.4 0.3; 0.2 0] [-0.5 -0.7; 0.5 -0.7]};
% Defina as resoluções desejadas
resolucoes = [100 100; 300 300; 800 600; 1920 1080];
% Loop através das diferentes resoluções
for i = 1:length(resolucoes)
    resolucao = resolucoes(i, :);
    % Crie uma matriz vazia para a imagem
    img = zeros(resolucao(1, 1), resolucao(1, 2));
    for j = 1:length(retasNormalizadas)
        retaTela = normParaTela(retasNormalizadas{j}, resolucao);
        img = rasterizarReta(retaTela, resolucao, img);
    end
    % Mostre a imagem
    subplot(2, 2, i);
    imshow(img);
    title(['Resolução: ' num2str(resolucao)]);
end
