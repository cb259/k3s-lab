Install Helm from script
https://www.youtube.com/watch?v=tZ8GMoOA4l0
https://helm.sh/docs/intro/install/#from-script
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

Point helm to K3S
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

Rancher Install
https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/install-upgrade-on-a-kubernetes-cluster
Use stable

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
kubectl create namespace cattle-system
# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true

kubectl get pods --namespace cert-manager

helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rancher.home.local \
  --set bootstrapPassword=admin

Create local DNS record

