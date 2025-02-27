# IaC Fundamentals with Terraform and Ansible

This project is part of the Infrastructure as Code (IaC) training provided by Alura School. The goal of this training is to teach the fundamentals of IaC using Terraform and Ansible.

## Project Structure

- **terraform/**: Directory containing Terraform configuration files.
  - **main.tf**: The main configuration file for Terraform.
- **ansible/**: Directory containing Ansible playbooks and configuration files.
  - **playbook.yml**: The main playbook file for Ansible.

## Prerequisites

- Terraform installed on your machine.
- Ansible installed on your machine.
- An account with a cloud provider (e.g., AWS, Azure, GCP).

## Getting Started

1. Clone the repository:
    ```sh
    git clone https://github.com/leonartdoss/alura.git
    cd alura/iac_fundamentals
    ```

### Terraform

2. Navigate to the Terraform directory:
    ```sh
    cd terraform
    ```

3. Initialize Terraform:
    ```sh
    terraform init
    ```

4. Apply the configuration:
    ```sh
    terraform apply
    ```

### Ansible

2. Navigate to the Ansible directory:
    ```sh
    cd ansible
    ```

3. Run the Ansible playbook:
    ```sh
    ansible-playbook playbook.yml
    ```

## Resources

- [Terraform Documentation](https://www.terraform.io/docs/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Alura](https://www.alura.com.br/)

## License

This project is licensed under the MIT License.

## Author

Leonardo Gama - [GitHub](https://github.com/leonartdoss)
