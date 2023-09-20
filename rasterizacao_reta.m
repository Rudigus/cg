retasNormalizadas = {[-0.5 -0.5; -0.5 0.5] [0.4 0.3; 0.2 0] [-0.5 -0.7; 0.5 -0.7]}
retasTela = {}
% intervalo normalizado: ambos x e y estão no intervalo de -1 a 1
resolucaoTela = [400 300]
for i = 1:numel(retasNormalizadas)
  retaTela = zeros(2,2)
  for j = 1:2
    retaTela(j,1) = resolucaoTela(1,1) * (-1 - retasNormalizadas{i}(j,1)) / -2
    retaTela(j,2) = resolucaoTela(1,2) * (-1 - retasNormalizadas{i}(j,2)) / -2
  end
  retasTela = [retasTela retaTela]
end
