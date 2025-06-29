{ pkgs, lib, config, inputs, ... }:

{
  packages = with pkgs; [ crystal shards crystalline ];
}
