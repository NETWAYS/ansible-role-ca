# ansible-role-ca

**NOTE** Not finished, not for production use

[![CI](https://github.com/netways/ansible-role-ca/workflows/Molecule%20Test/badge.svg?event=push)](https://github.com/netways/ansible-role-ca/workflows/Molecule%20Test/badge.svg)

A simple role to create a CA to create certificates and deploy them to hosts.

The intended use is to create certificates you can use for connecting clients to main systems. As there are several tools that require keys and certificates with different options set, the role should be able to create them, too. These more specialised keys and certificate must not replace the default ones. See [Contributing](#contributing) below for details. The idea is to run the role once on all hosts in the infrastructure to create all certificates and keys.

Some files are copied to the host you're running Ansible on.

This role is tested with:

* Rockylinux 9
* Rockylinux 10
* Ubuntu 22.04
* Ubuntu 24.04
* Debian 12

## Requirements ##

You need to have the Python library `cryptography` in version `>1.2.3` available. `PyOpenSSL` might also work, but is deprecated. Please note that different versions might have different requirements which ciphers to use. So watch your Playbook output and be ready to change `ca_openssl_cipher` if needed.

## Variables ##

* `ca_manage_openssl`: Install `openssl` package? (default: `true`)
* `ca_ca_dir`: Directory to place CA and certificates (default: `/opt/ca`)
* `ca_ca_dir_owner`: CA directory owner (default: `root`)
* `ca_ca_dir_group`: CA directory group (default: `root`)
* `ca_ca_days`: Runtime of the CA certificate (default: `3650`)
* `ca_ca_password`: Password of CA key (no default, should be defined by user)
* `ca_localdir`: Temporary directory on Ansible management host (default: `/tmp/ca`)
* `ca_local_become`: Use `become` on the Ansible controller. Used for creation of `ca_localdir`. (default: `false`)
* `ca_ca_host`: Hostname of the CA host (default: `localhost`)
* `ca_country`: Setting for certificates (omitted by default)
* `ca_state`: Setting for certificates (omitted by default)
* `ca_locality`: Setting for certificates (omitted by default)
* `ca_postalcode`: Setting for certificates (omitted by default)
* `ca_organization`: Setting for certificates (omitted by default)
* `ca_organizationalunit`: Setting for certificates (omitted by default)
* `ca_common_name`: CN for certificates (default: `{{ inventory_hostname }}`)
* `ca_email`: E-Mail address for certificates (omitted by default)
* `ca_altname_1`: First alt name (default: `{{ ansible_fqdn }}`)
* `ca_ca_signing_key_algorithm`: CA key generation algorithm (default: `RSA`)
* `ca_ca_keylength`: CA keylength (default: `2048`)
* `ca_server_cert`: Create server certificate as well (default: `true`)
* `ca_logstash`: Create Logstash compatible certificate as well. Needs `ca_server_cert` to be set. (default: `false`)
* `ca_etcd`: Create additional etcd compatible certificates. Requires `ca_etcd_group` to be defined. (default: `false`)
* `ca_etcd_group`: Needs to be set to the group name of etcd nodes and will add the default IPv4 address of each node to the certificates. 127.0.0.1 will also be added by the role to the SAN for loopback purposes.(default: `undefined`)
* `ca_keypassphrase`: Password for the client key, default not defined
* `ca_openssl_cipher`: Cipher to use for key creation, default not defined
* `ca_client_ca_dir`: Directory to place CA and certificates on the clients (default: `/opt/ca`)
* `ca_client_ca_dir_owner`: User to own the certificate directory on the clients (default: `root`)
* `ca_client_ca_dir_group`: Group to own the certificate directory on the clients (default: `root`)
* `ca_client_ca_dir_mode`: Permissions of the certificate directory on the clients (default: `0700`)
* `ca_client_key_algorithm`: Client key generation algorithm (default: `{{ ca_ca_signing_key_algorithm }}`)
* `ca_renew`: Renew certificates if they expire within `ca_check_valid_time` timeframe (default: `false`)
* `ca_valid_time`: Valid time of new created certificates (default: `+365d`)
* `ca_check_valid_time`: Timeframe to check if certificates will expire (default: `+2w`)

### Workarounds ###

Sometimes a very special combination of tools and versions requires a workaround that may only work in certain environments. We implement these usually with variables to turn them on or off. These are almost always temporary so we don't invest a lot in documentation. If you know, you need a certain setting, then activate the variable. If not, please leave it off because these workarounds usually have negative side effects.

These workarounds usually don't get their own test scenarios in molecule. They will be tested in local test systems and left as they are.

All of these have the default value `false`.

* `ca_ls7_workaround`: Enable pinning key parameters for a Logstash compatible key. These settings make sure the key works with a certain combination of OpenSSL and Logstash. Symptom: Logstash logs that a valid PKCS8 key is invalid.
* `ca_ls7_workaround_cipher`: The cipher to use for the workaround (default: `PBE-SHA1-RC4-128`)

## Notification handlers

It's possible to register handlers to run actions on certificate change. For example, to reload service and use the updated certificate.

The following handler names are available for registration:

* `ansible-role-ca : on certificate change`: runs on client certificate change
* `ansible-role-ca : on server certificate change`: runs on server certificate change
* `ansible-role-ca : on etcd certificate change`: runs on etcd certificate change
* `ansible-role-ca : on etcd server certificate change`: runs on etcd server certificate change


## Example Playbook ##

    - hosts: all
      roles:
        - ca
      handlers:
        - name: "ansible-role-ca : on certificate change"
          ansible.builtin.systemd_service:
            name: my_tls_service
            state: reloaded

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
