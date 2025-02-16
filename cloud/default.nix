{ pkgs, config, lib, ... }:
let
  location = "fsn1";
  hcloudImage = "ubuntu-24.04";
  # FIXME split to lines
  nixosInfect = "#cloud-config\nruncmd:\n- curl https://raw.githubusercontent.com/elitak/nixos-infect/5ef3f953d32ab92405b280615718e0b80da2ebe6/nixos-infect | PROVIDER=hetznercloud NIX_CHANNEL=nixos-unstable bash 2>&1 | tee /tmp/infect.log\n";
in {
  imports = [ ../secrets ];

  # srv1
  resource.hcloud_server.srv1 = {
    name        = "srv1";
    image       = hcloudImage;
    server_type = "cax31";
    location    = location;
    depends_on  = [ "hcloud_network_subnet.subnet" ];
    ssh_keys    = [ "main_key" ];
    user_data   = nixosInfect;
  };

  resource.hcloud_server_network.srv1-network = {
    server_id  = "\${hcloud_server.srv1.id}";
    network_id = "\${hcloud_network.network.id}";
    ip         = "192.168.3.1";
    alias_ips  = [ ];
  };

  # network
  resource.hcloud_network_subnet.subnet = {
    type         = "cloud";
    network_id   = "\${hcloud_network.network.id}";
    network_zone = "eu-central";
    ip_range     = "192.168.3.0/24";
  };

  resource.hcloud_network.network = {
    name     = "network";
    ip_range = "192.168.0.0/16";
  };

  # rdns
  resource.hcloud_rdns.master = {
    server_id  = "\${hcloud_server.srv1.id}";
    ip_address = "\${hcloud_server.srv1.ipv4_address}";
    dns_ptr    = "kozorezov.ru"; # FIXME hardcode
  };

  # base
  terraform = {
    required_providers.hcloud = {
      # FIXME use usual hashicorp/hcloud
      source  = "hetznercloud/hcloud";
      version = "= 1.48.1";
    };
  };
  provider.hcloud.token = config.mynixos.secrets.services.hetzner.apiToken;
  resource.hcloud_ssh_key.main_key = {
    name       = "main_key";
    public_key = config.mynixos.secrets.users.petrkozorezov.authPublicKey;
  };
}
