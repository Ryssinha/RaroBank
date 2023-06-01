# Raro Bank

Projeto prático Trabalho final Raro Academy.

## Setup inicial

Antes de iniciar a aplicação, recomenda-se a execução da seguinte sequência de comandos:

```bash
rvm use 3.2.1
cd raro_bank
bundle install
rails db:create
rails db:migrate
rails db:seed
sudo service postgresql start
```

Para iniciar o servidor, recomenda-se a utilização do comando `./bin/dev`, pois ele garante os assets serão todos devidamente processados.

Para subir o `MailCatcher` no terminal rode:

```bash
mailcatcher
```
Depois acesse a porta **`http://127.0.0.1:1080/`**.
