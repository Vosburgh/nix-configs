{ self, ... } @ inputs: {
  "nick@artorias" = self.lib.mkHome "nick" "artorias" "x86_64-linux";
}