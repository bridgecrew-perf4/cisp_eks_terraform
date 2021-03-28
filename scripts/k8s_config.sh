#!/bin/bash



AWS_REGION=$1
EKS_CLUSTER=$2
IAM_CLUSTER_ROLE=$3
IAM_LB_ROLE=$4

check_aws_credentials(){
  if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    echo "[ERROR] AWS_ACCESS_KEY_ID not defined, please check if your AWS credentials variables ware defined."
    exit 1
  fi

  if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "[ERROR] AWS_SECRET_ACCESS_KEY not defined, please check if your AWS credentials variables ware defined."
    exit 1
  fi
  
}

update_eks_kubeconfig(){

  aws eks --region $AWS_REGION update-kubeconfig --name $EKS_CLUSTER

  if [ $? != 0 ]; then
    echo "[ERROR] Something whent wrong when trying to update your kubeconfig"
    exit 1
  fi

}

apply_k8s_metric_server(){

  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

  if [ $? != 0 ]; then
    echo "[ERROR] Something whent wrong when trying to create the Metric Server"
    exit 1
  fi
  
}


apply_eks_cluster_autoscaler(){

  sed "s/<YOUR CLUSTER NAME>/$EKS_CLUSTER/g" manifests/cluster-autoscaler-autodiscover.yaml.tpl > manifests/cluster-autoscaler-autodiscover.yaml

  kubectl apply -f manifests/cluster-autoscaler-autodiscover.yaml

  kubectl annotate --overwrite=true serviceaccount cluster-autoscaler -n kube-system eks.amazonaws.com/role-arn=${IAM_CLUSTER_ROLE}

  kubectl patch deployment cluster-autoscaler \
  -n kube-system \
  -p '{"spec":{"template":{"metadata":{"annotations":{"cluster-autoscaler.kubernetes.io/safe-to-evict": "false"}}}}}'


  kubectl set image deployment cluster-autoscaler \
  -n kube-system \
  cluster-autoscaler=k8s.gcr.io/autoscaling/cluster-autoscaler:v1.18


}

apply_cert_manager(){

  kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.2/cert-manager.yaml
  sleep 60
}

apply_eks_alb_controller(){
  sed "s/<YOUR CLUSTER NAME>/$EKS_CLUSTER/g"  manifests/alb_controller.yaml.tpl > manifests/alb_controller.yaml
  
  kubectl apply -f manifests/alb_controller.yaml
 
  kubectl annotate --overwrite=true serviceaccount aws-load-balancer-controller -n kube-system eks.amazonaws.com/role-arn=${IAM_LB_ROLE}

}


#check_aws_credentials
#update_eks_kubeconfig
#apply_k8s_metric_server
#apply_eks_cluster_autoscaler
#apply_cert_manager
apply_eks_alb_controller

