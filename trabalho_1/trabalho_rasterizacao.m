% Arquivo de script
1;

clear all;

function pontoTela = pontoNormParaTela(pontoNormalizado, resolucao)
    larguraTela = resolucao(1, 1);
    alturaTela = resolucao(1, 2);
    pontoTela = zeros(1,2);
    pontoTela(1,1) = larguraTela * (1 + pontoNormalizado(1,1)) / 2;
    pontoTela(1,2) = alturaTela * (1 + pontoNormalizado(1,2)) / 2;
end

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
%{
function curvaTela = curvaNormParaTela(curvaNormalizada, resolucao)
    curvaTela = zeros(4,2);
    for i = 1:4
        curvaTela(i,:) = pontoNormParaTela(curvaNormalizada(i,:), resolucao);
    end
end
%}

function poligonoTela = poligonoNormParaTela(poligonoNormalizado, resolucao)
    numPontos = rows(poligonoNormalizado);
    poligonoTela = zeros(numPontos,2);
    for i = 1:numPontos
        poligonoTela(i,:) = pontoNormParaTela(poligonoNormalizado(i,:), resolucao);
    end
end

function [xp, yp] = produzFragmento(x,y)
    % Epsilon (eps) é utilizado para prevenir erros de ponto flutuante
    xm = floor(x + eps(1e4));
    ym = floor(y + eps(1e4));
    xp = xm + 1;
    yp = ym + 1;
end

% Seta um pixel da imagem fornecida nas coordenadas fornecidas,
% caso sejam coordenadas válidas
function img = setaPixel(x, y, img)
    numLinhas = rows(img);
    numColunas = columns(img);
    if x < 1 || x > numColunas || y < 1 || y > numLinhas
        return;
    end
    img(y, x) = 1;
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
        img = setaPixel(xp, yp, img);
        while (x < x2)
            x = x + 1;
            y = m * x + b;
            [xp, yp] = produzFragmento(x, y);
            img = setaPixel(xp, yp, img);
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
        img = setaPixel(xp, yp, img);
        while (y < y2)
            y = y + 1;
            x = m * y + b;
            [xp, yp] = produzFragmento(x, y);
            img = setaPixel(xp, yp, img);
        end
    end
end

function img = rasterizarCurva(curvaNormalizada, numPontos, img)
    pontos = zeros(numPontos,2);
    for i = 1:numPontos
        t = (i - 1) * (1 / (numPontos - 1));
        pontoNormalizado = [t^3 t^2 t 1] * [2 -2 1 1; -3 3 -2 -1; 0 0 1 0; 1 0 0 0] ...
                      * curvaNormalizada;
        pontos(i,:) = pontoNormParaTela(pontoNormalizado, [columns(img) rows(img)]);
    end
    for i = 1:numPontos - 1
        reta = [pontos(i,:); pontos(i + 1,:)];
        img = rasterizarReta(reta, img);
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

function plotarReta(reta)
    plot(reta(:, 1), reta(:, 2), "color", "k");
end

function plotarCurva(curva, numPontos)
    pontos = zeros(numPontos,2);
    for i = 1:numPontos
        t = (i - 1) * (1 / (numPontos - 1));
        pontos(i,:) = [t^3 t^2 t 1] * [2 -2 1 1; -3 3 -2 -1; 0 0 1 0; 1 0 0 0] ...
                      * curva;
    end
    for i = 1:numPontos - 1
        reta = [pontos(i,:); pontos(i + 1,:)];
        plotarReta(reta);
    end
end

function plotarPoligono(poligono)
    fill(poligono(:, 1), poligono(:, 2), "k");
end

global imgs = {};

function atualizarPlot(obj, init = false)
    global imgs;
    h = guidata(obj);
    % Defina as resoluções desejadas
    resolucoes = [100 100; 300 300; 800 600; 1920 1080];
    % Mostra o espaço normalizado
    subplotPosition = [0.2 0.75 0.2 0.2];
    subplot("position", subplotPosition);
    xlim([-1 1]);
    ylim([-1 1]);
    hold on;
    title(sprintf('Espaço Normalizado'), "fontSize", 10);
    set(gca, 'YDir','reverse');
    axis("square");
    % Loop através das diferentes resoluções
    for i = 1:length(resolucoes)
        resolucao = resolucoes(i, :);
        % Crie uma matriz vazia para a imagem
        if init
            imgs = [imgs zeros(resolucao(1, 2), resolucao(1, 1))];
        end
        img = imgs{1, i};
        switch gcbo
            case h.botaoAdicionarReta
                x1 = str2num(get (h.campoPontoReta1, "string"));
                x2 = str2num(get (h.campoPontoReta2, "string"));
                retaNormalizada = [x1; x2];
                retaTela = retaNormParaTela(retaNormalizada, resolucao);
                img = rasterizarReta(retaTela, img);
                if i == 1
                    plotarReta(retaNormalizada);
                end
            case h.botaoAdicionarCurva
                x1 = str2num(get (h.campoPontoCurva1, "string"));
                x2 = str2num(get (h.campoPontoCurva2, "string"));
                t1 = str2num(get (h.campoTangenteCurva1, "string"));
                t2 = str2num(get (h.campoTangenteCurva2, "string"));
                numPontos = str2num(get (h.campoNumPontos, "string"));
                curvaNormalizada = [x1; x2; t1; t2];
                %curvaTela = curvaNormParaTela(curvaNormalizada, resolucao);
                img = rasterizarCurva(curvaNormalizada, numPontos, img);
                if i == 1
                    plotarCurva(curvaNormalizada, numPontos);
                end
            case h.botaoAdicionarPoligono
                poligonoNormalizado = str2num(get (h.campoArestasPoligono, "string"));
                poligonoTela = poligonoNormParaTela(poligonoNormalizado, resolucao);
                img = rasterizarPoligono(poligonoTela, img);
                if i == 1
                    plotarPoligono(poligonoNormalizado);
                end
        end
        % Mostre a imagem
        switch i
            case 1
                subplotPosition = [0 0.4 0.25 0.25];
            case 2
                subplotPosition = [0.3 0.4 0.25 0.25];
            case 3
                subplotPosition = [0 0.05 0.25 0.25];
            case 4
                subplotPosition = [0.3 0.05 0.25 0.25];
        end
        subplot("position", subplotPosition);
        imshow(img);
        title(sprintf('Resolução: %d x %d', resolucao));
        imgs{1, i} = img;
    end
end

% Reta
h.rotuloTituloReta = uicontrol ("style", "text",
                          "units", "normalized",
                          "string", "Reta:",
                          "horizontalalignment", "left",
                          "position", [0.6 0.9 0.35 0.08]);

h.rotuloCampoPontoReta1 = uicontrol ("style", "text",
                          "units", "normalized",
                          "string", "Ponto 1:",
                          "horizontalalignment", "left",
                          "position", [0.6 0.85 0.1 0.08]);

h.campoPontoReta1 = uicontrol ("style", "edit",
                          "units", "normalized",
                          "string", "",
                          "position", [0.68 0.85 0.1 0.06]);

h.rotuloCampoPontoReta2 = uicontrol ("style", "text",
                          "units", "normalized",
                          "string", "Ponto 2:",
                          "horizontalalignment", "left",
                          "position", [0.8 0.85 0.1 0.08]);

h.campoPontoReta2 = uicontrol ("style", "edit",
                          "units", "normalized",
                          "string", "",
                          "position", [0.88 0.85 0.1 0.06]);

h.botaoAdicionarReta = uicontrol ("style", "pushbutton",
                                "units", "normalized",
                                "string", "Adicionar Reta",
                                "callback", @atualizarPlot,
                                "position", [0.6 0.75 0.35 0.09]);

% Curva
h.rotuloTituloCurva = uicontrol ("style", "text",
                          "units", "normalized",
                          "string", "Curva:",
                          "horizontalalignment", "left",
                          "position", [0.6 0.65 0.35 0.08]);

h.rotuloCampoPontoCurva1 = uicontrol ("style", "text",
                          "units", "normalized",
                          "string", "Ponto 1:",
                          "horizontalalignment", "left",
                          "position", [0.6 0.60 0.1 0.08]);

h.campoPontoCurva1 = uicontrol ("style", "edit",
                          "units", "normalized",
                          "string", "",
                          "position", [0.68 0.60 0.1 0.06]);

h.rotuloCampoPontoCurva2 = uicontrol ("style", "text",
                          "units", "normalized",
                          "string", "Ponto 2:",
                          "horizontalalignment", "left",
                          "position", [0.8 0.60 0.1 0.08]);

h.campoPontoCurva2 = uicontrol ("style", "edit",
                          "units", "normalized",
                          "string", "",
                          "position", [0.88 0.60 0.1 0.06]);

h.rotuloCampoTangenteCurva1 = uicontrol ("style", "text",
                          "units", "normalized",
                          "string", "Tangente 1:",
                          "horizontalalignment", "left",
                          "position", [0.6 0.5 0.1 0.08]);

h.campoTangenteCurva1 = uicontrol ("style", "edit",
                          "units", "normalized",
                          "string", "",
                          "position", [0.71 0.5 0.08 0.06]);

h.rotuloCampoTangenteCurva2 = uicontrol ("style", "text",
                          "units", "normalized",
                          "string", "Tangente 2:",
                          "horizontalalignment", "left",
                          "position", [0.8 0.5 0.1 0.08]);

h.campoTangenteCurva2 = uicontrol ("style", "edit",
                          "units", "normalized",
                          "string", "",
                          "position", [0.91 0.5 0.08 0.06]);

h.rotuloCampoNumPontos = uicontrol ("style", "text",
                          "units", "normalized",
                          "string", "Número de pontos:",
                          "horizontalalignment", "left",
                          "position", [0.6 0.4 0.18 0.08]);

h.campoNumPontos = uicontrol ("style", "edit",
                          "units", "normalized",
                          "string", "",
                          "position", [0.77 0.4 0.08 0.06]);

h.botaoAdicionarCurva = uicontrol ("style", "pushbutton",
                                "units", "normalized",
                                "string", "Adicionar Curva",
                                "callback", @atualizarPlot,
                                "position", [0.6 0.3 0.35 0.09]);

% Polígono
h.rotuloTituloPoligono = uicontrol ("style", "text",
                          "units", "normalized",
                          "string", "Polígono:",
                          "horizontalalignment", "left",
                          "position", [0.6 0.22 0.35 0.08]);

h.rotuloCampoArestasPoligono = uicontrol ("style", "text",
                          "units", "normalized",
                          "string", "Arestas:",
                          "horizontalalignment", "left",
                          "position", [0.6 0.15 0.1 0.08]);

h.campoArestasPoligono = uicontrol ("style", "edit",
                          "units", "normalized",
                          "string", "",
                          "position", [0.68 0.15 0.2 0.06]);

h.botaoAdicionarPoligono = uicontrol ("style", "pushbutton",
                                "units", "normalized",
                                "string", "Adicionar Polígono",
                                "callback", @atualizarPlot,
                                "position", [0.6 0.05 0.35 0.09]);

set(gcf, "color", get(0, "defaultuicontrolbackgroundcolor"))
guidata(gcf, h)
atualizarPlot(gcf, true);

