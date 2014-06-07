--Aluno: Lucas Gabriel
--Disciplina: TCP-IP & Roteamento
--Implementação do algoritmo Dijkstra

--Constante
local infinito = 1000000

--Método para a leitura do conteúdo da matriz.
function read_line_content(nome_arquivo)

	--Estrutura para receber o conteúdo de cada linha do arquivo.
	linhas = {}

	--O método io.lines() realiza a leitura do arquivo iterando por linhas.
	for linha in io.lines(nome_arquivo) do
		linhas[#linhas + 1] = linha
	end

	return linhas

end --Fim read_line_content

--Método para a instanciação de uma matriz.
function create_matrix(linhas)
	local matriz = {}
	local indice = 1

	for linha in pairs(linhas) do
		local m = {}
		
		for tok in string.gmatch(linhas[linha], "[^%s]+") do
			if tonumber(tok) == infinito then
				table.insert(m,infinito)
			else
				table.insert(m,tonumber(tok))
			end
		end

		--Em lua a criação de uma matriz é feita determinando um vetor em formato
		--de coluna para cada posição do vetor.
		matriz[linha] = m
		m = {}
		indice = indice + 1

	end

	return matriz

end --Fim create_matrix

--Método utilizado para calcular a dimensão do arquivo.
function linesOf_archive(file)
	local quantidade = 0

	for linhas, linha in pairs(file) do
		
		quantidade = quantidade + 1

	end

	return quantidade

end --Fim linesOf_archive

--Método que implementa o algoritmo do Dijkstra, que recebe como parâmetros o arquivo da matriz.
--o host_origem que é o host que inicia o caminho, e o host_destino que é o host onde a rota termina.
function dijkstra(matriz,host_origem,host_destino)
	--O uso do símbolo # acompanhado de uma variável, retorna o tamanho ocupado por essa variável,
	local length = #matriz

	--Vetores para o tratamento de cada host da matriz.
	local vetor_distancia = {}
	local vetor_permanencia = {}
	local vetor_caminho = {}

	local new_dist = 0
	local small_dist = 0
	local d = 0


	for indice = 1, length do
		vetor_distancia[indice] = infinito
		vetor_caminho[indice] = 0
	end

	for index = 1,length do
		vetor_permanencia[index] = 0
	end

	vetor_permanencia[tonumber(host_origem)] = 1
	vetor_distancia[tonumber(host_origem)] = 0

	--Define o host corrente para percorrer durante a busca do caminho
	local corrente = host_origem
	local host_corrente = corrente

	while corrente ~= host_destino do
		small_dist = infinito
		d = vetor_distancia[tonumber(corrente)]

		for indice = 1, length do
			if vetor_permanencia[indice] == 0 then
				--Calcula a distância partindo do host corrente ao host adjacente.
				new_dist = d + matriz[tonumber(corrente)][tonumber(indice)]

				--Se a distância for menor, o vetor de distância é atualizado.
				if new_dist < vetor_distancia[indice] then
					vetor_distancia[indice] = new_dist
					vetor_caminho[indice] = corrente
				end

				--Define o host com menor ditância.
				if vetor_distancia[indice] < small_dist then
					small_dist = vetor_distancia[indice]
					host_corrente = indice
				end

			end

		end --Fim loop for

		--Abaixo é tratada a condição para que o algoritmo não entre
		--em loop infinito, validando se os hosts corrente e o host
		--a ser pesquisado são os mesmos.
		if corrente == host_corrente then
			break
		end

		corrente = host_corrente
		vetor_permanencia[tonumber(corrente)] = 1

	end --Fim loop while

	--Exibindo o resultado no console.
	print("Rota: ")

	local rota = host_destino
	local resposta = ""
	local vetor_resposta = {}
	local posicao = 1

	for indice = 1, length do
		--print("Caminho[" .. indice .. "]",path[indice])
	end

	vetor_resposta[posicao] = host_destino
	posicao = posicao + 1

	while rota ~= host_origem do
		vetor_resposta[posicao] = vetor_caminho[tonumber(rota)]
		posicao = posicao + 1
		rota = vetor_caminho[tonumber(rota)]
		
		if rota ~= host_origem  then
			--resposta = resposta .. " <- "
		end

	end --Fim do loop while

	for indice = 0, #vetor_resposta do
		if indice ~= #vetor_resposta then
			resposta = resposta .. " -> " .. vetor_resposta[#vetor_resposta - indice]
		end

	end

	print(resposta)

	print("Custo: ", vetor_distancia[tonumber(host_destino)])

	--print("Caminho: ".. resposta)

end --Fim Dijkstra

--Abaixo o parâmetro arg que é recebido no terminal é subdividido nas partes que contém
--o nome do arquivo, o host de origem e o host de destino. Estes 3 argumentos que serão
--passados como argumento para o algoritmo do dijkstra.
nome_arquivo = arg[1]
host_origem = arg[2]
host_destino = arg[3]

local arquivo = nome_arquivo
local total_linhas = read_line_content(arquivo)

--Instancia a matriz de roteamento.
matriz_roteamento = create_matrix(total_linhas)

--Chamada do método do dijkstra.
dijkstra(matriz_roteamento,host_origem,host_destino)