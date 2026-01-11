# Host-Specific Variables

This directory contains per-host variable files for Ansible. Each file corresponds to a host defined in `inventory.ini`.

## Usage

Create a file named after your host (must match the name in inventory.ini):

```yaml
# host_vars/container1.yml
ansible_user: root
ansible_password: specific_password_for_container1
```

## Encrypting Host Variables

You can encrypt individual host variable files:

```bash
ansible-vault encrypt host_vars/container1.yml
```

## Example Structure

```
host_vars/
├── container1.yml (encrypted)
├── container2.yml (encrypted)
└── webserver.yml (encrypted)
```

This approach is useful when:
- Different containers have different credentials
- You want granular control over which credentials are committed
- You're managing many containers with varying access levels
