# Leilão de estoque

## Sistema de Leilões em Ruby on Rails

Bem-vindo ao sistema de leilões! Este é um aplicativo web construído com Ruby 3.0.2 e Rails 7.0.4 que permite a criação, gestão e participação em leilões.

### Pré-requisitos

Para executar este projeto, você precisará:

- Ruby 3.0.2
- Rails 7.0.4
- SQlite3

### Configuração do Projeto

1. **Clone o repositório**

   ```
   git clone https://github.com/WladimirOSZ/estoque.git
   cd estoque
   ```

2. **Instale as dependências**

   ```
   bundle install
   ```

3. **Configuração do Banco de Dados**

   ```
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Inicie o servidor Rails**

   ```
   rails server
   ```
   
Agora o projeto deve estarn disponível em: `localhost:3000`.

### Características do Sistema

- Autenticação de Usuários: Usuários podem se registrar, fazer login e logout.
- Usuários criados com o email @leilaodogalpao.com.br serão automaticamente usuários administradores.
- Criação de Leilões: Usuários administradores podem criar novos leilões, definindo um título, descrição, preço inicial, e data de encerramento e posteriormente adicionando items.
- Participação em Leilões: Usuários autenticados (não administradores) podem dar lances em leilões ativos.
- Finalização de Leilões: Leilões são automaticamente encerrados em sua data de encerramento, e o lance mais alto é considerado o vencedor. Após a finalização o administrador aprova ou cancela um lote. Caso aprovado, será listado nos lotes vencidos para o usuário. Caso reprovado, os items voltam a ser disponibilizados para os serem adicionados em lotes.

### Testes

Este projeto usa testes. Para rodar os testes, use o seguinte comando:

```
rspec
```
### Links adicionais
### [Trello](https://trello.com/invite/b/oYFKGeZ8/ATTI4938053632fa7ccf55b703b69fae810264FF2D38/auction-lot)
