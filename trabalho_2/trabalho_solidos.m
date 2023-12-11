% Arquivo de script
1;

function [vertices, arestas] = construirCircunferencia(raio)
    t = (0:pi/8:2*pi)';
    numVertices = rows(t);
    vertices = [raio * sin(t), raio * cos(t), zeros(numVertices, 1), ones(numVertices, 1)];
    arestas = [(1:numVertices - 1)' (2:numVertices)'];
    arestas = [arestas; numVertices 1];
end

function vertices = transladarSolido(verticesSolido, vetorTranslacao)
    tx = vetorTranslacao(1);
    ty = vetorTranslacao(2);
    tz = vetorTranslacao(3);
    matrizTranslacao = [1 0 0 tx; 0 1 0 ty; 0 0 1 tz; 0 0 0 1]';
    vertices = verticesSolido * matrizTranslacao;
end

function [vertices, arestas] = construirCilindro(raioTampa, altura, numCircunferencias)
    [vTampaInferior, aTampaInferior] = construirCircunferencia(raioTampa);
    vertices = vTampaInferior;
    arestas = aTampaInferior;
    for i = 1:numCircunferencias+1
        [vc, ac] = construirCircunferencia(raioTampa);
        vc = transladarSolido(vc, [0, 0, (i / (numCircunferencias + 1)) * altura]);
        vertices = [vertices; vc];
        numVertices = rows(vc);
        ac = ac + i * numVertices;
        arestas = [arestas; ac];
        arestasVerticais = [ac(:, 1), ac(:, 1) - numVertices];
        arestas = [arestas; arestasVerticais];
    end
end

function [vertices, arestas] = construirCone(raioTampa, altura, numCircunferencias)
    [vTampaInferior, aTampaInferior] = construirCircunferencia(raioTampa);
    vertices = vTampaInferior;
    arestas = aTampaInferior;
    for i = 1:numCircunferencias+1
        [vc, ac] = construirCircunferencia((numCircunferencias + 1 - i) * raioTampa / (numCircunferencias + 1));
        vc = transladarSolido(vc, [0, 0, (i / (numCircunferencias + 1)) * altura]);
        vertices = [vertices; vc];
        numVertices = rows(vc);
        ac = ac + i * numVertices;
        arestas = [arestas; ac];
        arestasVerticais = [ac(:, 1), ac(:, 1) - numVertices];
        arestas = [arestas; arestasVerticais];
    end
end

function [vertices, arestas] = construirEsfera(raioEsfera, numCircunferencias)
    [vFundoEsfera, aFundoEsfera] = construirCircunferencia(0);
    vertices = vFundoEsfera;
    arestas = aFundoEsfera;
    for i = 1:numCircunferencias+1
        h = (i / (numCircunferencias + 1)) * raioEsfera * 2;
        [vc, ac] = construirCircunferencia(sqrt(h * (2 * raioEsfera - h)));
        vc = transladarSolido(vc, [0, 0, h]);
        vertices = [vertices; vc];
        numVertices = rows(vc);
        ac = ac + i * numVertices;
        arestas = [arestas; ac];
        arestasVerticais = [ac(:, 1), ac(:, 1) - numVertices];
        arestas = [arestas; arestasVerticais];
    end
end

function plotarSolido(vertices, arestas)
    view(3);
    hold on;
    for a = arestas'
        v1 = vertices(a(1), :);
        v2 = vertices(a(2), :);
        valoresPlot = [v1; v2];
        plot3(valoresPlot(:, 1), valoresPlot(:, 2),  valoresPlot(:, 3), "color", "k");
    end
end

xlim([-3 3]);
ylim([-3 3]);
zlim([-3 3]);
raio = 1;
[verticesCilindro, arestasCilindro] = construirCilindro(raio, raio * 2, 9);
[verticesCone, arestasCone] = construirCone(raio, raio * 3, 9);
verticesCone = transladarSolido(verticesCone, [0 -2 0]);
[verticesEsfera, arestasEsfera] = construirEsfera(raio, 20);
verticesEsfera = transladarSolido(verticesEsfera, [0 2 0]);
plotarSolido(verticesCilindro, arestasCilindro);
plotarSolido(verticesCone, arestasCone);
plotarSolido(verticesEsfera, arestasEsfera);

