#!/bin/bash
URL=$API_URL
API_KEY=$API_KEY
FILE_PATH="docker-compose.yml"

# Faz a solicitação GET e armazena a resposta em uma variável
response=$(curl -s -X GET "$URL" -H "X-API-Key: $API_KEY" --insecure)

# Verifica se a stack com nome "back" está criada
if echo "$response" | jq -e '.[] | select(.Name == "back")' > /dev/null; then
  # Extrai o valor do campo "Name" resposta usando jq
  name=$(echo "$response" | jq -r '.[] | select(.Name == "back") | .Name')

  # Imprime o nome da stack
  echo "A Stack chamada $name está criada. Nome: $name"

  # Obtém o ID da stack
  id=$(echo "$response" | jq -r '.[] | select(.Name == "back") | .Id')
  
  # Imprime o ID da stack
  echo "Obtendo ID da stack: $id"
  # Monta a URL para a exclusão
  DELETE_URL="$URL/$id"
  
  # Faz a solicitação DELETE usando curl
  curl -X DELETE "$DELETE_URL" \
  -H "X-API-Key: $API_KEY" \
  -F "type=2" \
  -F "method=file" \
  -F "file=@$FILE_PATH" \
  -F "endpointId=2" \
  -F "Name=back" 

  echo "Stack deletada. ID: $id"
  echo "vamos dormir por 30 segundos"
  sleep 30
  echo "CRIANDO A STACK $name"

  response=$(curl -s -X POST "$URL" \
  -H "X-API-Key: $API_KEY" \
  -F "type=2" \
  -F "method=file" \
  -F "file=@$FILE_PATH" \
  -F "endpointId=2" \
  -F "Name=back" )

  # Imprimir a resposta completa para depuração
  echo "Resposta da solicitação POST: $response"

  # Extrair o valor do campo "Id" da nova stack usando jq
  id=$(echo "$response" | jq -r '.Id')

  # Imprimir o valor do Id
  echo "Nova Stack criada. Id: $id"
else
  echo "Nenhuma Stack da aplicão encontrada."
  echo "CRIANDO NOVA STACK "

  response=$(curl -s -X POST "$URL" \
  -H "X-API-Key: $API_KEY" \
  -F "type=2" \
  -F "method=file" \
  -F "file=@$FILE_PATH" \
  -F "endpointId=2" \
  -F "Name=back" )

  # Imprimir a resposta completa para depuração
  echo "Resposta da solicitação POST: $response"

  # Extrair o valor do campo "Id" da nova stack usando jq
  id=$(echo "$response" | jq -r '.Id')

  # Imprimir o valor do Id
  echo "Nova Stack criada. Id: $id"
fi
