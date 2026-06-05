function __aws_profile_profiles
    set -l profiles (aws configure list-profiles --output text | string split " ")

    if test (count $profiles) -eq 0
        return 1
    end
    
    printf "%s\n" $profiles
end

complete --command aws-profile --no-files --condition "not __fish_seen_subcommand_from get set unset" --arguments get --description "Show current AWS profile"
complete --command aws-profile --no-files --condition "not __fish_seen_subcommand_from get set unset" --arguments set --description "Set AWS profile"
complete --command aws-profile --no-files --condition "not __fish_seen_subcommand_from get set unset" --arguments unset --description "Unset AWS profile"
complete --command aws-profile --no-files --condition "__fish_seen_subcommand_from set" --arguments "(__aws_profile_profiles)" --description "AWS profile"
