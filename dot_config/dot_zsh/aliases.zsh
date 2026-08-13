# Alias
# ---
#
alias code="open -a 'Visual Studio Code'"

alias ls="eza --icons --group-directories-first -l"
alias gs="git status"
alias e.="open ."
alias gundo="git reset --soft HEAD~1"
alias awswhoami="aws sts get-caller-identity"
alias awslist="aws ec2 describe-instances"
alias tf="terraform"
alias tfp="terraform plan"
alias tfa="terraform apply $1"
alias tfay="terraform apply --auto-approve"
alias tfd="terraform destroy"
