# ansible-role-ca

**NOTE** Not finished, not for production use

[![CI](https://github.com/widhalmt/ansible-role-ca/workflows/Molecule%20Test/badge.svg?event=push)](https://github.com/widhalmt/ansible-role-ca/workflows/Molecule%20Test/badge.svg)

A simple role to create a CA to create certificates and deploy them to hosts.

The intended use is to create certificates you can use for connecting clients to main systems.

## Variables ##

* `ca_ca_days`: Runtime of the CA certificate (default: `3650`)
