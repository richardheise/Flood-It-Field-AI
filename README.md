
# Resolutor do jogo Flood Field (Inteligência Artifical)

## Descrição:
 - Este trabalho propõe-se a resolver tabuleiros do jogo Flood It (também conhecido como Flood Field ou Flood Fill) utilizando uma inteligência artifical programada em C++.

## O Problema
 - Como visto em aula, uma IA que resolve o Flood Field de maneira ótima -- isto é, sempre com a melhor sequência de jogadas -- pode ser obtida através de um algoritmo como o A*. Acontece que estamos limitados a 8GB de RAM e 2 minutos no máximo de execução de código, ou seja, conclui que seria inviável abrir todas as possibilidades e, portanto, resolvi implementar um algoritmo guloso (greedy) que utiliza-se de uma boa heurística, previsão de jogadas e detecção de possíveis jogadas para chegar a uma solução razoável em tempo hábil.

## Código
 ### O código fonte possui três bibliotecas locais: matriz.h, IAra.h e floodlib.h. 
 - Em IAra.h (uma pequena piada com o nome hehe) você encontrará as funções referentes à IA em si.
 - Em matriz.h você encontrará funções referentes ao alocamento e controle de dados de um tabuleiro (matriz de char).
 - Em floodlib.h você encontrará funções referentes à implementação do jogo flood field.

 - Para mais informações aqui recomendo rodar o comando doxygen, que gerará uma documentação automática do código.

## Fluxo
 - Em flood.cpp temos nossa main(), ela chamará a leitura das entradas, do tabuleiro e, por fim, chamará resolve() que resolverá o jogo.
 - A função resolve() executa um laço em que se busca a melhor jogada; joga-se, então, a melhor jogada e guarda esta jogada em uma lista de jogadas que será escrita na tela ao fim.
 - A função que busca a melhor jogada descobrirá, através de outra função, as possíveis jogadas. Em seguida é calculado se haverá previsão de jogadas e quantas deverão ser previstas para cada jogada (essa parte é crucial para o melhor desempenho do código e envolve uma expressão matemática obtida através de testes, mais detalhes no comentário no código em IAra.cpp), logo roda-se um laço para jogadas possíveis, testando-as e guardando a heurística relativa a cada jogada em uma lista que associa cor a uma heurística. Assim que temos todas nossas possíveis jogadas devidamente testadas, escolhemos a de menor score (detalhes da heurística) e a retornamos como sendo a melhor jogada.

## Heurística 
  - Há duas heurística aqui: número de regiões do tabuleiro dividido pelo número de cores e distância de cada ponto do tabuleiro referente ao cluster principal. Uma região é um cluster de uma só cor, ou seja, em um tabuleiro 6 por 6, por exemplo, podem haver, no máximo, 6x6 regiões, sendo cada ponto de uma cor diferente de modo que elas nunca formam uma região maior que dois. 
  - A primeira heurística conta quantas regiões temos em um tabuleiro e divide esse valor pelo número de cores, dando-nos um valor real que estima quantas áreas faltam ser abertas para resolvermos o tabuleiro.
  - A segunda heurística, e essa sim é nosso "carro chefe", calcula a distância de cada ponto da matriz em relação ao nosso nodo principal, a melhor jogada é a que diminui a maior distância. 

  - Essas heurísticas são somadas, a jogada que tem a menor soma é a melhor. A parte boa da heurística ser um valor real é que não precisamos criar critério de desempate: se duas jogadas diminuem a mesma distância do nodo maais longe, será jogada a que abre mais regiões devido a primeira heurística descrita. Se ainda assim empatamos, então as duas jogadas são boas.

## Prevendo a melhor jogada
  - Se considerarmos um tabuleiro da seguinte forma:

   1 2 2 1

   3 1 2 1

   2 1 1 1

   1 1 1 1

  Teremos quatro possíveis soluções: 
  
  1-> 2 1 3 2
  
  2-> 2 1 2 3
  
  3-> 3 2 1
  
  4-> 3 1 2

  Perceba que as duas últimas resolvem o tabuleiro mais rapidamente do que as duas primeiras, ou seja, seria ideal se nosso código conseguisse atingí-la através da heurística, porém, infelizmente a heurística não resolverá esse tabuleiro de forma ideal, o único modo de fazer isso é olhando, para cada jogada possível, qual dela resultará na melhor composição do tabuleiro daqui a algumas jogadas. Para isso, a função preveJogada() foi criada.

  ### preveJogada() 
  - Primeiro, recebemos um tabuleiro em que foi executada alguma jogada possível, em seguida, vemos quais são as possíveis jogadas para nosso tabuleiro, rodamos um loop para cada qual dessas e guardamos cada jogada associada a uma heurística em uma lista. Depois, escolhemos a melhor jogada dentre as possíveis e a aplicamos no tabuleiro para que possamos rodar todo esse passo mais uma vez (caso seja interessante). 

  - Sabemos quantas jogadas devemos prever no futuro de acordo com a equação _número de previsoes_ = -4.7961 * ln(_número de possíveis cores_) + 14.715. Essa equação foi descoberta através de testes empíricos, ela dá 0 para 20 possíveis cores, quando não prevemos nenhuma jogada e somente usamos a heurística a fim de manter o código dentro de nossa janela de dois minutos. 
  #### O teste empírico
   - O teste empírico foi realizado da seguinda forma: um script foi rodado gerando 5 tabuleiros aleatórios de tamanho 100 100 com k cores, a variável k foi sendo incrementada começando com 4 até 20, ou seja, gerei tabuleiros diferentes até 100 x 100 com 20 cores e conclui que com a previsão de uma única jogada no futuro seria impossível rodar em menos de 2 minutos, então, marcamaos o ponto (20,0) em um gráfico de previsões no futuro por cores possíveis. Esse teste me revelou que com uma previsão meu limite seria 19 cores e, finalmente, com duas previsões seria 14 cores. Coloquei nossos três pontos ( {(20,0);(19,1);(14,2)} ) em um gráfico e gerei uma curva que se aproximava de todos os pontos, essa curve é descrita pela equação supracitada de _número de previsoes_.

  - Ao final, retornamos uma heurística que será associada à jogada que chamou a função de previsão. Também somamos com a heurística qual profundidade estamos para que a jogada que resolve o tabuleiro antes tenha vantagem quando comparada com as demais.

  - SEMPRE tentamos prever para cada jogada quantas jogadas no futuro devemos olhar, para isso aquela equação de número de previsões existe. Mais detalhes nos comentários do código em IAra.cpp.

## Considerações finais
  - Use o comando make para compilar, make clean limpa os .o e make purge limpa todo executável e .o gerado.
  - Você pode, se desejar e eu recomendo, gerar documentação automática usando o comando doxygen. Ele gerará um relatório completo do código em html e latex.

## Para rodar
  - Basta usar o comando make, fazer ./flood < _linhas_ _colunas_ _cores_ _matriz do tabuleiro_.

#### Autor
 - Feito com carinho, esforço e suor por Richard Fernando Heise Ferreira (rfhf19@inf.ufpr.br) para a disciplina de Inteligência Artifical, ministrada durante o ERE de 2021 devido à pandemia. Espero que goste :)



