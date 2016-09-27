# README

### Instalação

1. Copie este repositório
2. Crie um arquivo chamado .env na raiz do projeto com este conteúdo:

```
DEVELOPMENT_DATABASE=<nome_do_banco_de_desenvolvimento>
TEST_DATABASE=<nome_do_banco_de_testes>
```

Na raiz do projeto, execute:
```
$ bundle install
$ rake db:setup && rake db:setup RAILS_ENV=test
$ rake db:migrate && rake db:migrate RAILS_ENV=test
```

Se quiser, crie um usuário pelo console
```
$ rails console
> User.create email: 'admin@example.com', password: 'somepassword', password_confirmation: 'somepassword'
````

### Testes

Na raiz do projeto
```
rspec spec
```

Existem dois testes "fora do padrão" que servem para testar um fluxo padrão de uso da API, estão em spec/api_features/. Estes são os testes que você deve ler pra entender a aplicação.

```
rspec spec/api_features/
````

### Observações

1. Acabei fazendo uma aplicação em Rails com banco de dados pois acredito que querer simplificar e deixar os dados na memória ia me causar mais problemas do que resolver.
2. Utilizei a gem [devise_token_auth](https://github.com/lynndylanhurley/devise_token_auth) para autenticação. A autenticação está testada, mas não tem mais nada testado. Em um projeto real eu testaria tudo para verificar falhas de segurança, permitir criação de usuários, etc. Esta gem utiliza um token no header para autenticação.
3. Não adicionei o campo "unidade" nas requisições pois isso só faria sentido se eu fizesse também algum código responsável pela conversão de unidades. Então a API espera que os valores sejam dados em metros (lançamento de dardo) ou segundos (100 metros rasos)
4. O código está com 100% de cobertura de testes (segundo a gem [simplecov](https://github.com/colszowka/simplecov)).
5. Organizei o git bonitinho, veja com git log ou:

```
git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
```

### Vários polimentos poderiam ser feitos

1. Criar um objeto para armazenar as informações sobre o vencedor de uma competição. (No momento usa uma Hash).
2. Especificar status de http para todas as respostas. Por exemplo, quando uma validação do ActiveRecord falha, a API responde com 200 mas inclúi os erros na resposta. Muitas APIs fazem isso, mas eu poderia polir o código pra incluir uma resposta mais no dialeto do http (talvez 400?).
3. Todas as mensagens estão hard-coded. Um polimento legal seria utilizar códigos ao invés de strings, facilitando inclusive a internacionalização no futuro.
4. Permitir especificação e validação de unidades (3 ponto das observações).