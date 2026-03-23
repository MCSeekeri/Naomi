{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    minikube
    kind
    kubectl
    kubernetes
    k9s
    kubetui

    kubernetes-helm

    helm-dashboard
    k3s
    podman-desktop
  ];
}
