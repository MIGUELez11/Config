function aws-profile
    switch $argv[1]
        case "get"
            if test -z "$AWS_PROFILE"
                echo "AWS_PROFILE not set"
                return 0
            end

            echo "AWS_PROFILE set to $AWS_PROFILE"
        case "set"
            set -Ux AWS_PROFILE $argv[2]
            echo "AWS_PROFILE set to $AWS_PROFILE"
        case "unset"
            if test -z "$AWS_PROFILE"
                echo "AWS_PROFILE not set"
                return 0
            end

            set -e AWS_PROFILE
            echo "AWS_PROFILE unset"
        case "*"
            echo "Usage: aws-profile [get|set|unset]"
            return 1
    end
end
