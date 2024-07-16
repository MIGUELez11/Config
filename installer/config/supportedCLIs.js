const supportedCLIs = {
  "@miguelez11/aws-assume-role": {
    provider: "local",
    name: "aws/aws_assume_role.sh",
    completion: "aws/aws_assume_role_completion.sh",
    dependencies: ["aws", "jq"],
  },
  "@miguelez111/aws-profile": {
    provider: "local",
    name: "aws/aws_profile.sh",
    completion: "aws/aws_profile_completion.sh",
    dependencies: ["aws"],
  },
  "@miguelez111/aws-transfer-ecr": {
    provider: "local",
    name: "aws/aws_transfer_ecr.sh",
    dependencies: ["aws", "jq"],
  },

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
