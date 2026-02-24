☁️ AWS Infrastructure as Code (IaC)


Este repositório contém a definição da infraestrutura como código para um ambiente escalável e seguro na AWS. O objetivo deste projeto é automatizar o provisionamento de recursos, garantindo consistência, versionamento e rapidez no deploy do ambiente.

🏗️ Arquitetura do Ambiente
A infraestrutura foi desenhada seguindo as melhores práticas do AWS Well-Architected Framework, incluindo:

VPC (Virtual Private Cloud): Rede isolada com subnets públicas e privadas.

Instâncias EC2 / ECS: Provisionamento de computação para hospedar as APIs desenvolvidas anteriormente.

RDS (Relational Database Service): Banco de dados gerenciado para suportar o E-commerce e o sistema de pagamentos.

S3 Buckets: Armazenamento de arquivos estáticos e logs.

Security Groups: Regras rígidas de firewall para controlar o tráfego de entrada e saída.

🛠️ Tecnologias Utilizadas
Cloud Provider: AWS (Amazon Web Services).

IaC Tool: Terraform (ou AWS CloudFormation/CDK).

CLI: AWS CLI para gerenciamento via terminal.

📂 Estrutura de Pastas
/modules: Componentes reutilizáveis de infraestrutura (Rede, DB, App).

/environments: Configurações específicas para ambientes de Dev, Staging e Produção.

main.tf / template.yaml: Arquivo principal de definição dos recursos.

🚀 Como Provisionar
Configure suas credenciais AWS:

Bash
aws configure
Inicie o diretório do Terraform:

Bash
terraform init
Visualize o plano de execução:

Bash
terraform plan
Aplique as mudanças:

Bash
terraform apply
🧠 Aprendizados Chave
Imutabilidade: Entendimento de que a infraestrutura deve ser destruída e recriada, nunca alterada manualmente.

Segurança Cloud: Aplicação do princípio de privilégio mínimo em roles do IAM.

Custo-Eficiência: Escolha de instâncias e recursos que otimizam o gasto financeiro no provedor cloud.
