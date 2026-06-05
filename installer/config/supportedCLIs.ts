export interface CliPackage {
  provider: string;
  name: string;
}

const supportedCLIs: Record<string, CliPackage> = {
  aws: {
    provider: "homebrew",
    name: "awscli",
  },
  jq: {
    provider: "homebrew",
    name: "jq",
  },
  fuck: {
    provider: "homebrew",
    name: "thefuck",
  },
  terraform: {
    provider: "homebrew",
    name: "terraform",
  },
};

export default supportedCLIs;
