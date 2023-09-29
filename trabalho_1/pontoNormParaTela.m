function pontoTela = pontoNormParaTela(pontoNormalizado, resolucao)
    larguraTela = resolucao(1, 1);
    alturaTela = resolucao(1, 2);
    pontoTela = zeros(1,2);
    pontoTela(1,1) = larguraTela * (1 + pontoNormalizado(1,1)) / 2;
    pontoTela(1,2) = alturaTela * (1 + pontoNormalizado(1,2)) / 2;
end
