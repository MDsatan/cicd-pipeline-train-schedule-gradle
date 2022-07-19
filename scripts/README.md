# Scripts for Proj

To make it work don't forget to use:
   
    az login


1) main.tf to deploy infrastructure in Azure
2) buildnode.sh used in Terraform to install software on BuildNode (Jenkins, Docker , Gradle, Terraform, SonarQube CLI, Common SSH Key, etc)
3) install_master.sh used in Terraform to deploy K8s master node
4) install_worker.sh used in Terraform to deploy K8s worker node
