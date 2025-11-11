{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    minikube
    kind
    kubectl
    kubernetes
    docker-machine-kvm2 # https://github.com/kubernetes/minikube/issues/6023
    k9s
    kubetui

    kubernetes-helm

    helm-dashboard
    k3s
    podman-desktop
  ];
}
