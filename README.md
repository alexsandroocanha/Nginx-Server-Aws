<img width="606" height="141" alt="image" src="https://github.com/user-attachments/assets/5655e846-5e51-4d2a-994c-47a8d1b700a1" /># Servidor Web-Nginx

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

**Usuario**
Na pagina profile, você tera que inserir o nome do seu Profile definido para realizar uma conexão sso:
<img width="606" height="141" alt="image" src="https://github.com/user-attachments/assets/b5562008-015d-4dc7-8c9f-5396ecc880c5" />

**Região**

Por padrão, o servidor está configurado para iniciar na Por padrão, o servidor está configurado para iniciar na região "us-east-1". Caso deseje utilizar outra região, será necessário modificar os seguintes pontos:

- A região no bloco provider
<img width="606" height="141" alt="image" src="https://github.com/user-attachments/assets/b5562008-015d-4dc7-8c9f-5396ecc880c5" />

- A variável availability_zone, localizada no arquivo variables.tf
<img width="650" height="120" alt="image" src="https://github.com/user-attachments/assets/6031b175-4cd5-4fcb-9283-a51113bd0433" />


**Chave SSH**

Você precisará configurar o caminho e o nome da sua chave SSH pública.
<img width="636" height="141" alt="image" src="https://github.com/user-attachments/assets/a7a6f685-a28e-47b9-8b26-3aa925b45eb1" />

Por padrão, ela está localizada na pasta ./ssh, dentro do diretório home do Linux. Essa chave pública será enviada para a instância EC2, permitindo a autenticação via SSH e o acesso remoto à máquina.

**Email de Notificação**

Não se esqueça de configurar o e-mail para receber as notificações do CloudWatch.
No arquivo de variáveis, substitua o valor "email@user.com" pelo e-mail do usuário que deve receber os alertas.
<img width="698" height="171" alt="image" src="https://github.com/user-attachments/assets/cbbd77c5-ee05-4e9d-a52f-551f083c316a" />

⚠️ Importante
Você precisará confirmar o recebimento (opt-in) através de um e-mail enviado pela AWS após a criação da infraestrutura.

## Modificações Arquivo-Bash

Além das configurações em Terraform, também é necessário alterar alguns parâmetros nos scripts Bash:

**Configuração de WebHook**

O servidor foi integrado a um script que envia uma mensagem de erro sempre que ele detecta que o **serviço caiu**.
Além disso, uma mensagem com a data e hora da queda é armazenada em **log**.

Para utilizar a função de WebHook, você precisará substituir a seguinte linha:
<img width="681" height="112" alt="image" src="https://github.com/user-attachments/assets/122d92b1-bc2a-4f8f-a5bf-cb03f3dab35c" />

Essa linha está localizada dentro do arquivo script.sh, dentro da pasta configurações/.


⚠️ Importante:
O script já está disponível em um **repositório público no GitHub.**
Para que funcione corretamente, você deve alterar o **link raw.githubusercontent.com** dentro do arquivo s**etup-nginx.sh** (na pasta Scripts/) e apontar para o seu fork ou uma cópia própria, se desejar editar.

**Configuração Pagina HTML**

Para exibir sua própria página **HTML** no servidor Nginx, altere o link raw usado no script de instalação.
No arquivo setup-nginx.sh, localizado dentro do diretório Scripts, substitua o link atual por um link raw válido para a página HTML de sua escolha, como por exemplo:
<img width="1028" height="85" alt="image" src="https://github.com/user-attachments/assets/1c542a5c-bf76-47bc-80b6-712dd8f90cd0" />

⚠️ Importante:
A página HTML deve estar hospedada em um **repositório público no GitHub.**
Você precisa alterar o link raw no arquivo** setup-nginx.sh** (dentro da pasta Scripts/) para apontar para o seu arquivo HTML.

## Informações para Contato
Caso tenha dúvidas, sinta-se à vontade para entrar em contato:

Entre em contato:
alexsandroocanha@gmail.com
[Linkedin](https://www.linkedin.com/in/alexsandro-ocanha-rodrigues-77149a35b/)
