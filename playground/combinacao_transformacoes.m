O = [0 0; 2 0; 1 1];
A = [1 3; 3 2; 2 1];
mEscala = [2 0; 0 1];
mReflexao = [-1 0; 0 -1];
mCisalhamento = [1 0; 0.3 1];
transformacao1 = mReflexao * mCisalhamento * mEscala * O';
transformacao2 = mReflexao * mEscala * mCisalhamento * O';
transformacao3 = mCisalhamento * mReflexao * mEscala * O';
transformacao4 = mCisalhamento * mEscala * mReflexao * O';
transformacao5 = mEscala * mCisalhamento * mReflexao * O';
transformacao6 = mEscala * mReflexao * mCisalhamento * O';
transformacoes = {transformacao1' transformacao2', transformacao3', ...
                  transformacao4', transformacao5', transformacao6'};
cores = ['k' 'r' 'g' 'b' 'y' 'm']
numTransformacoes = length(transformacoes);
hold on
for i = 1:numTransformacoes
    transformacao = transformacoes{1, i};
    transformacao(4, :) = transformacao(1, :);
    plot(transformacao(:, 1), transformacao(:, 2), "color", cores(1, i));
end
