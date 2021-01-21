# Projeto de Implementação do EKS, ECR e RDS via Terraform


Para utilizar esse projeto é necessário exportar as variáveis de autenticação da AWS. Isso pode ser feito via variáveis de ambiente do linux como mostrado abaixo:

```
export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxx"
export AWS_DEFAULT_REGION="xx-xxxx-x"
```

## Arquivos presentes neste repo

| Arquivo           | Descrição |
|   ---             |    ---    |
| bucket            | Dentro deste diretório estão os arquivos necessários para realizar o deploy do bucket S3 e DynamoDB que são necessários para o backend do terraform |
| ecr.tf            | Responsável realizar o deploy dos repositórios do ECR |
| eks_cluster.tf    | Responsável por criar o cluster do EKS |
| eks_node_group.tf | Responsável por realizar o deploy do grupo de nós utilizados pelo EKS |
| iam-eks-alb.tf    | Responsável pelo permissionamento do EKS para gerenciar o Load Balancer |
| iam.tf            | Responsável pelo permissionamento geral do cluster | 
| main.tf           | Neste arquivo estão as configurações gerais do terraform, como o backend e zona da AWS |
| output.tf         | Este arquivo armazena as informações geradas durante o deploy do projeto|
| rds.tf            | Responsável pelo deploy do banco de dados no RDS |
| README.md         | Documentação do projeto | 
| security_group.tf | Responsável por realizar a criação do SG para as instâncias | 
| variables.tf      | Arquivo com as váriaveis utilizadas pelo projeto |
| vpc.tf            | Responsável por criar as redes para uso do cluster |
