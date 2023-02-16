# OCI MySQL Service for Development

Deploy a MySQL DB System on Oracle Cloud for development with access with a OCI Bastion host in port forwarding mode.

> Not working:
> Bastion ssh port forwarding is not working, review [blog](https://blogs.oracle.com/mysql/post/using-oci-cloud-shell-bastion-with-mysql-database-service).

## Deploy

Deploy MySQL and Bastion host:
```bash
npx zx deploy.mjs
```

> Print output:
> 
> ```bash
> npx zx deploy.mjs output
> ```

## Clean

Deploy MySQL and Bastion host:
```bash
npx zx deploy.mjs clean
```

