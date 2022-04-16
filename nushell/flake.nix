{
  description = "The latest Nu shell";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }:
    {
      packages = builtins.listToAttrs
        (map
          (system:
            with import nixpkgs { inherit system; };
            {
              name = system;
              value = {
                default = nushell.overrideAttrs (attrs: rec {
                    pname = "nushell";
                    version = "0.61.0";
                    src = fetchFromGitHub {
                        owner = pname;
                        repo = pname;
                        rev = version;
                        sha256 = "1qfqn22qabm0jrr4yqq9rb29k8qj9w9g0j9x4n8h0zp28vn7c2bq";
                    };
                    cargoSha256 = "sha256-gZ91rRyp5a7MjG9yM0pGCBYtM4GylZg7Sg9wCiB+SW0=";
                });
              };
            })
          [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
        );
    };
}
