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
  tldr: {
    provider: "homebrew",
    name: "tldr",
  },
};

export default supportedCLIs;
