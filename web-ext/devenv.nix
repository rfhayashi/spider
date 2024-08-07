{ pkgs, lib, config, inputs, ... }:

{
  packages = with pkgs; [ nodejs web-ext ];

  scripts.squint.exec = ''
    npm run squint "$@"
  '';

  processes = {
    squint.exec = "squint watch";
    webpack.exec = "npm run watch";
    tests.exec = "npm run test --watch";
  };
}
