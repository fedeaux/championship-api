# README

### Instalação

1. Copie este repositório
2. Crie um arquivo chamado .env na raiz do projeto com este conteúdo:

```
DEVELOPMENT_DATABASE=<nome_do_banco_de_desenvolvimento>
TEST_DATABASE=<nome_do_banco_de_testes>
DEVELOPMENT_DATABASE_PASSWORD=<senha_do_banco_dev> (pode ficar em branco se o banco não precisar de senha)
TEST_DATABASE_PASSWORD=<senha_do_banco_test> (pode ficar em branco se o banco não precisar de senha)
```

(O sistema foi feito e testado com postgresql, mas outros bancos parecidos (como MySQL) devem functionar, mas precisaria mudar mais configurações)

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

Rode o servidor com
```
$ rails server
```

Ele estará escutando requisições em http://localhost:3000

Você pode utilizar, de um terminal

```
curl -v -X POST -F 'email=admin@example.com' -F 'password=somepassword' localhost:3000/auth/sign_in
```

A opção -v mostra os headers, procure por "access-token" e "client" e adicione aos headers das requisições que requerem autenticação

```
curl -XPOST -H 'Content-Type: application/json' -H 'access-token: Lj36tYDQho9N4Rgm00pC1w' -H 'client: OwiG5y0Y81qVZtlwqnJ4Ig' -H "uid: admin@example.com" localhost:3000/api/championships
```

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
3. Não adicionei o campo "unidade" nas requisições pois isso só faria sentido se eu fizesse também algum código responsável pela conversão de unidades, ou obrigasse o usuário a sempre mandar a mesma unidade. Então a API simplesmente espera que os valores sejam dados em metros (lançamento de dardo) ou segundos (100 metros rasos).
4. Tentei fazer o código o mais open closed possível. Adicionar um tipo de Championship deve ser possível só criando duas classes: NewTypeOfChampionship e NewTypeOfPerformance.
5. A join table entre Athlete e Championship se refere ao Athlete como competitor. Isso facilitaria transformar este campo em polimorfico para, por exemplo, deixar que times possar ser utilizados no lugar de atletas.
6. O código está com 100% de cobertura de testes (segundo a gem [simplecov](https://github.com/colszowka/simplecov)). Abra coverage/index.html para ver um relatório de cobertura.
7. Não criei testes específicos para os controllers por falta de tempo/necessidade. Os request_specs testam os controllers indiretamente.
8. Foram em torno de 10h dedicadas a este projeto.
9. Organizei o git bonitinho, veja com git log ou:

```
git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
```



### Vários polimentos poderiam ser feitos

1. Criar um objeto para armazenar as informações sobre o vencedor de uma competição. (No momento usa uma Hash e filtra alguns campos no model).
2. Especificar status de http para todas as respostas. Por exemplo, quando uma validação do ActiveRecord falha, a API responde com 200 mas inclúi os erros na resposta. Muitas APIs fazem isso, mas eu poderia polir o código pra incluir uma resposta mais no dialeto do http (talvez 400?).
3. Todas as mensagens estão hard-coded. Um polimento legal seria utilizar códigos ao invés de strings, facilitando inclusive a internacionalização no futuro.
4. Permitir especificação e validação de unidades (3 ponto das observações).