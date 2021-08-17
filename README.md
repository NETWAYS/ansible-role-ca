# ansible-role-ca

**NOTE** Not finished, not for production use

[![CI](https://github.com/widhalmt/ansible-role-ca/workflows/Molecule%20Test/badge.svg?event=push)](https://github.com/widhalmt/ansible-role-ca/workflows/Molecule%20Test/badge.svg)

A simple role to create a CA to create certificates and deploy them to hosts.

The intended use is to create certificates you can use for connecting clients to main systems.

The current version is only tested with CentOS 7. If you want to use other OS'es please note that the name of Molecule instance is hardcoded within `converge.yml`

Some files are copied to the host you're running Ansible on.

## Variables ##

* `ca_manage_openssl`: Install `openssl` package? (default: `true`)
* `ca_manage_python`: Install Python libraries (default: `true`)
* `ca_ca_dir`: Directory to place CA and certificates (default: `/opt/ca`)
* `ca_ca_days`: Runtime of the CA certificate (default: `3650`)
* `ca_ca_password`: Password of CA key (default: `ChangeMe`)
* `ca_localdir`: Temporary directory on Ansible management host (default: `/tmp/ca`)
* `ca_ca_host`: Hostname of the CA host (default: `localhost`)
* `ca_country`: Setting for certificates (default: `EX`)
* `ca_state`: Setting for certificates (default: `EX`)
* `ca_locality`: Setting for certificates (default: `EX`)
* `ca_postalcode`: Setting for certificates (default: `1234`)
* `ca_organization`: Setting for certificates (default: `example`)
* `ca_organizationalunit`: Setting for certificates (default: `example`)
* `ca_common_name`: CN for certificates (default: `{{ ansible_hostname }}`)
* `ca_email`: E-Mail address for certificates (default: `root@{{ ansible_fqdn }}`)
* `ca_altname_1`: First alt name (default: `{{ ansible_fqdn }}`)
* `ca_ca_keylength`: CA keylength (default: `2048`)
* `ca_keypassphrase`: Password for the client key (default: `ChangeMeAgain`)

## Example Playbook ##

    - hosts: all
      roles:
        - ca
## License ##

GPLv3+

Author Information
------------------

This role was created in 2021 by Thomas Widhalm <widhalmt@widhalm.or.at>

Some code used from:

* https://benjaminknofe.com/blog/2018/07/08/logstash-authentication-with-ssl-certificates/
* https://gquintana.github.io/2020/11/28/Build-your-own-CA-with-Ansible.html
