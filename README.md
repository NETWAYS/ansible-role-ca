# ansible-role-ca

**NOTE** Not finished, not for production use

[![CI](https://github.com/netways/ansible-role-ca/workflows/Molecule%20Test/badge.svg?event=push)](https://github.com/netways/ansible-role-ca/workflows/Molecule%20Test/badge.svg)

A simple role to create a CA to create certificates and deploy them to hosts.

The intended use is to create certificates you can use for connecting clients to main systems. As there are several tools that require keys and certificates with different options set, the role should be able to create them, too. These more specialised keys and certificate must not replace the default ones. See [Contributing](#contributing) below for details. The idea is to run the role once on all hosts in the infrastructure to create all certificates and keys.

The current version is only tested with CentOS 7 and Rocky 8.

Some files are copied to the host you're running Ansible on.

## Requirements ##

You need to have the Python library `cryptography` in version `>1.2.3` available. `PyOpenSSL` might also work, but is deprecated. Please note that different versions might have different requirements which ciphers to use. So watch your Playbook output and be ready to change `ca_openssl_cipher` if needed.

## Variables ##

* `ca_manage_openssl`: Install `openssl` package? (default: `true`)
* `ca_ca_dir`: Directory to place CA and certificates (default: `/opt/ca`)
* `ca_ca_days`: Runtime of the CA certificate (default: `3650`)
* `ca_ca_password`: Password of CA key (default: `ChangeMe`)
* `ca_localdir`: Temporary directory on Ansible management host (default: `/tmp/ca`)
* `ca_local_become`: Use `become` on the Ansible controller. Used for creation of `ca_localdir`. (default: `false`)
* `ca_ca_host`: Hostname of the CA host (default: `localhost`)
* `ca_country`: Setting for certificates (default: `EX`)
* `ca_state`: Setting for certificates (default: `EX`)
* `ca_locality`: Setting for certificates (default: `EX`)
* `ca_postalcode`: Setting for certificates (default: `1234`)
* `ca_organization`: Setting for certificates (default: `example`)
* `ca_organizationalunit`: Setting for certificates (default: `example`)
* `ca_common_name`: CN for certificates (default: `{{ inventory_hostname }}`)
* `ca_email`: E-Mail address for certificates (default: `root@{{ ansible_fqdn }}`)
* `ca_altname_1`: First alt name (default: `{{ ansible_fqdn }}`)
* `ca_ca_keylength`: CA keylength (default: `2048`)
* `ca_server_cert`: Create server certificate as well (default: `true`)
* `ca_logstash`: Create Logstash compatible certificate as well. Needs `ca_server_cert` to be set. (default: `false`)
* `ca_etcd`: Create etcd compatible certificate as well. Requires `ca_etcd_hosts` to be defined. (default: `false`)
* `ca_etcd_hosts`: This variable needs to be a list with all IP addresses of each etcd cluster member to allow communication between them. 127.0.0.1 will be added automatically by the role to the SAN for loopback purposes.(default: `undefined`)
* `ca_keypassphrase`: Password for the client key, default not defined
* `ca_openssl_cipher`: Cipher to use for key creation, default not defined
* `ca_client_ca_dir`: Directory to place CA and certificates on the clients (default: `/opt/ca`)
* `ca_client_ca_dir_owner`: User to own the certificate directory on the clients (default: `root`)
* `ca_client_ca_dir_group`: Group to own the certificate directory on the clients (default: `root`)
* `ca_client_ca_dir_mode`: Permissions of the certificate directory on the clients (default: `0700`)

## Example Playbook ##

    - hosts: all
      roles:
        - ca

## Contributing ##

Contributions are very welcome! Please make sure you stick to the following rules:

* The role must be able to run once on all hosts in the inventory and create all keys and certificates. You can not introduce changes that need an extra run with different variables. Of course, if you want, you can have different variable sets and run it several times e.g. to have more than one CA. It's about parameters for more specialised keys and certificates, they must not interfere with the existing ones.
* If you want to introduce a new kind of key or certificate, please make sure to create it additionally to the current variants. This role is used in projects where every host relies on a certificate created by this role. Changing the existing ones might break it.
* If you create new files that could be used for different usecases, please use a suffix that explains what kind of file you're providing. e.g. We introduced keys in PKCS8 format to use for Logstash. But since other tools might want to use them, too, we added `-pkcs8` as suffix. So the filenames are `instance.key` for the default one and `instance-pkcs8.key`.
* If you create files that are dedicated to a certain service and shouldn't be used by anything else, use the name of the service/tool as suffix. For example when you add all IPs within a cluster to SAN that's very specific. So add a suffix naming the tool you build them for.

## License ##

GPLv3+

Author Information
------------------

This role was created in 2021 by Thomas Widhalm <widhalmt@widhalm.or.at>
Moved Maintainer to NETways in 2022

Some code used from:

* https://benjaminknofe.com/blog/2018/07/08/logstash-authentication-with-ssl-certificates/
* https://gquintana.github.io/2020/11/28/Build-your-own-CA-with-Ansible.html
