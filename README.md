# Servidor Web-Nginx

Este projeto provisiona automaticamente uma infraestrutura completa na AWS usando **Terraform**, configurando um servidor web estático com **Nginx**, monitoramento via script **CloudWatch** e alertas por e-mail/Discord.

## Visão Geral

- Infraestrutura como código com **Terraform**
- Configuração automática do Nginx via **User Data** com **Bash Script**
- Rede segmentada com **subnets públicas e privadas**
- Alertas automáticos via **CloudWatch**, **SNS (e-mail)** e **WebHook**
- Deploy simples e direto na AWS

## Tecnologias Utilizadas

- **AWS (EC2, VPC, Subnets, Security Groups, CloudWatch, SNS)**
- **Terraform**
- **Shell Script**
- **Nginx**

## Arquitetura

- **VPC** customizada com 4 sub-redes:
  - 2 **públicas** (com acesso à Internet)
  - 2 **privadas** (sem acesso direto à Internet)
- Instância **EC2 t2.micro** configurada via **User Data**
- **Security Groups** controlando o tráfego HTTP (porta 80) e SSH (porta 22)
- Alarmes configurados com **CloudWatch** + **SNS** para notificações

## Modificações Terraform

Para utilizar este projeto, você terá que configurar alguns parâmetros:

**Região**

Por padrão, o servidor está configurado para iniciar na Por padrão, o servidor está configurado para iniciar na região "us-east-1". Caso deseje utilizar outra região, será necessário modificar os seguintes pontos:

- A região no bloco provider
- A variável availability_zone, localizada no arquivo variables.tf

**Chave SSH**

Você precisará configurar o caminho e o nome da sua chave SSH pública.

Por padrão, ela está localizada na pasta ./ssh, dentro do diretório home do Linux. Essa chave pública será enviada para a instância EC2, permitindo a autenticação via SSH e o acesso remoto à máquina.

**Email de Notificação**

Não se esqueça de configurar o e-mail para receber as notificações do CloudWatch.
No arquivo de variáveis, substitua o valor "email@user.com" pelo e-mail do usuário que deve receber os alertas.

⚠️ Importante: Você precisará confirmar o recebimento (opt-in) através de um e-mail enviado pela AWS após a criação da infraestrutura.

## Modificações Arquivo-Bash

Além das configurações em Terraform, também é necessário alterar alguns parâmetros nos scripts Bash:

**Configuração de WebHook**

O servidor foi integrado a um script que envia uma mensagem de erro sempre que ele detecta que o **serviço caiu**.
Além disso, uma mensagem com a data e hora da queda é armazenada em **log**.

Para utilizar a função de WebHook, você precisará substituir a seguinte linha:

Essa linha está localizada dentro do arquivo script.sh, dentro da pasta configurações/.


Atenção:
O script já está disponível em um **repositório público no GitHub.**
Para que funcione corretamente, você deve alterar o **link raw.githubusercontent.com** dentro do arquivo s**etup-nginx.sh** (na pasta Scripts/) e apontar para o seu fork ou uma cópia própria, se desejar editar.

**Configuração Pagina HTML**

Para exibir sua própria página **HTML** no servidor Nginx, altere o link raw usado no script de instalação.

No arquivo setup-nginx.sh, localizado dentro do diretório Scripts, substitua o link atual por um link raw válido para a página HTML de sua escolha, como por exemplo:


Atenção:
A página HTML deve estar hospedada em um **repositório público no GitHub.**
Você precisa alterar o link raw no arquivo** setup-nginx.sh** (dentro da pasta Scripts/) para apontar para o seu arquivo HTML.

## Informações para Contato


## Informações para Contato
Caso tenha dúvidas, sinta-se à vontade para entrar em contato:

Entre em contato:
alexsandroocanha@gmail.com
[Linkedin](https://www.linkedin.com/in/alexsandro-ocanha-rodrigues-77149a35b/)