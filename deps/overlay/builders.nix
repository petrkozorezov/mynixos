# TODO test
{ pkgs, lib, ... }: {
  openssl = rec {
    # keys must be ED25519 to be determined
    # /CN=example.com
    makeCertSignRequest = { key, domain }: let
      domainCnf = ''
        [ req ]
        prompt = no
        distinguished_name = dn
        req_extensions = req_ext

        [ dn ]
        CN = ${domain}

        [ req_ext ]
        subjectAltName = @alt_names

        [ alt_names ]
        DNS.1 = ${domain}
        '';
    in
      pkgs.runCommandLocal "certificate-sign-request-${domain}" {} ''
        echo "${domainCnf}" > domain.cnf
        ${pkgs.openssl}/bin/openssl req -new -config domain.cnf -key ${key} -out $out
        '';
    # TODO remove domain from signing if possible
    signCert = { csr, startdate, enddate, caKey, caCrt, domain }:
      let
        opensslCnf = ''
          [ ca ]
          default_ca = CA_default

          [ CA_default ]
          dir               = ./demoCA
          new_certs_dir     = \$dir/newcerts
          database          = \$dir/index.txt
          serial            = \$dir/serial
          certificate       = ${caCrt}
          private_key       = ${caKey}
          default_md        = sha256
          policy            = policy_any

          [ policy_any ]
          commonName        = supplied

          [ v3_req ]
          subjectAltName    = @alt_names

          [ alt_names ]
          DNS.1 = ${domain}
          '';
      in
        pkgs.runCommandLocal "certificate" {} ''
          mkdir -p demoCA/newcerts
          touch demoCA/index.txt
          echo $(sha1sum ${csr} | cut -f 1 -d " ") > demoCA/serial
          echo "${opensslCnf}" > openssl.cnf
          ${pkgs.openssl}/bin/openssl ca -config openssl.cnf -in ${csr} -startdate ${startdate} -enddate ${enddate} -extensions v3_req -batch -out $out
          '';
    makeCert = { key, domain, startdate, enddate, caCrt, caKey }:
      signCert {
        csr = makeCertSignRequest { inherit key domain; };
        inherit startdate enddate caCrt caKey domain;
      };
  };
}
