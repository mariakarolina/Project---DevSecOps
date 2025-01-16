# Project---DevSecOps


Este documento apresenta a criação de um sistema automatizado para monitoramento do estado de um servidor Nginx, implementado em dois ambientes distintos: uma máquina local utilizando o Windows Subsystem for Linux (WSL) com Ubuntu e uma instância Ubuntu hospedada na AWS. O projeto foi desenvolvido com um script que verifica periodicamente o status do servidor, registrando os resultados em arquivos de log para fins de análise e auditoria. A automação é gerenciada por tarefas agendadas no cron, configuradas para executar verificações a cada cinco minutos, garantindo um monitoramento contínuo e eficaz. Esta solução destaca competências em configuração de ambientes Linux, automação com scripts shell e uso de ferramentas de agendamento, sendo útil tanto para aprendizado quanto para aplicações práticas em administração de sistemas.

# Objetivos do Projeto
- Configurar um subsistema Ubuntu no ambiente AWS, no Windows WSL (Windows Subsystem for Linux), ou Ubuntu local no WSL.  
- Subir o servidor Nginx como ambiente de teste.  
- Desenvolver um script para validar se o serviço Nginx está online.  
- Registrar no script a data e hora da validação, o nome do serviço, o status do serviço e uma mensagem personalizada indicando "ONLINE" ou "OFFLINE".  
- Salvar os registros gerados pelo script em um diretório pré-definido.  
- Automatizar a execução do script para rodar a cada 5 minutos.


# Parte Prática

1. Criar um Ambiente Linux no Windows

Utilizando o WSL (Windows Subsystem for Linux), crie um subsistema do Ubuntu 20.04 ou superior.
Comando de instalação do WSL
Abra o PowerShell ou o Prompt de Comando no modo administrador (botão direito > "Executar como administrador").
Insira o comando:

wsl --install
Reinicie o computador após a instalação
Instalar o Ubuntu no WSL
Baixe o Ubuntu 20.04 ou superior na Microsoft Store.
Mais detalhes sobre o ambiente estão disponíveis em: https://ubuntu.com/desktop/wsl

2. Configurar a Infraestrutura AWS

#### Criar uma VPC (Virtual Private Cloud)
2.1 Acesse o console da AWS.
2. Navegue para o serviço **VPC** e clique em **Your VPCs** > **Create VPC**.
3. Preencha as informações:
   - **Name tag**: Nome da VPC (ex.: `MyVPC`).
   - **IPv4 CIDR block**: Ex.: `10.0.0.0/16`.
4. Clique em **Create VPC**.

#### Criar uma Sub-rede Pública
1. No console do VPC, vá para **Subnets** > **Create Subnet**.
2. Preencha os campos:
   - **Name tag**: Nome da sub-rede (ex.: `MyPublicSubnet`).
   - **VPC**: Selecione a VPC criada.
   - **Availability Zone**: Escolha uma zona de sua preferência.
   - **IPv4 CIDR block**: Ex.: `10.0.1.0/24`.
3. Clique em **Create Subnet**.

#### Associar um Gateway de Internet
1. No console do VPC, vá para **Internet Gateways** > **Create Internet Gateway**.
2. Preencha:
   - **Name tag**: Nome do gateway (ex.: `MyInternetGateway`).
3. Clique em **Create Internet Gateway**.
4. Depois de criado, selecione o gateway, clique em **Actions** > **Attach to VPC** e escolha sua VPC.

#### Configurar a Tabela de Rotas
1. No console do VPC, vá para **Route Tables** > **Create Route Table**.
2. Preencha:
   - **Name tag**: Nome da tabela de rotas (ex.: `MyRouteTable`).
   - **VPC**: Selecione a VPC criada.
3. Clique em **Create**.
4. Selecione a tabela criada, vá para a aba **Routes**, clique em **Edit Routes** e adicione:
   - **Destination**: `0.0.0.0/0` (para tráfego público).
   - **Target**: Selecione o gateway de internet.
5. Vá para a aba **Subnet Associations** e associe a tabela à sub-rede pública.

#### Configurar um Security Group
1. No console do EC2, vá para **Security Groups** > **Create Security Group**.
2. Preencha:
   - **Name tag**: Nome do grupo (ex.: `MySecurityGroup`).
   - **Description**: Ex.: `Permitir acesso SSH e HTTP`.
   - **VPC**: Selecione sua VPC.
3. Na seção **Inbound Rules**, adicione as regras:
   - **Type**: `SSH`, **Port Range**: `22`, **Source**: `My IP` .
   - **Type**: `HTTP`, **Port Range**: `80`, **Source**: `0.0.0.0/0`.
4. Clique em **Create Security Group**.

---

### 2. Criar uma Instância EC2 Ubuntu
1. Acesse o console da AWS e vá para **EC2** > **Launch Instance**.
2. Preencha as informações:
   - **Name**: Nome da instância (ex.: `MyUbuntuInstance`).
   - **AMI**: Escolha o Ubuntu 20.04 LTS.
   - **Instance Type**: Escolha `t2.micro` (gratuito no Free Tier).
   - **Key Pair**: Crie ou selecione um par de chaves para acesso SSH.
   - **Network Settings**: 
     - **VPC**: Selecione sua VPC.
     - **Subnet**: Escolha sua sub-rede pública.
     - **Auto-assign Public IP**: Habilitado.
   - **Security Group**: Use o grupo criado anteriormente.

