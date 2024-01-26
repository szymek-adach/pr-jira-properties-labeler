#!/usr/bin/env zsh

github_token=''
jira_token='mail:token' #base64 encoded

for i in {330..338}
do
   pr_title=$(
        curl -L \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: Bearer $github_token" \
            -H "X-GitHub-Api-Version: 2022-11-28" \
            "https://api.github.com/repos/eskygroup/esky-content-providers/pulls/$i" --no-progress-meter | jq --raw-output .title
    )

    regex="([A-Z]{3}-[0-9]{5}).*"

    if [[ $pr_title =~ $regex ]]
    then
        echo "Matched $pr_title"
        jira_code=${match[1]}
        echo $jira_code
    else
        echo "No regex match, skipping $pr_title"
        continue;
    fi

   issue_type_id=$(
        curl -X GET \
            -H "Content-type: application/json" \
            -H "Authorization: Basic $jira_token" \
            "https://eskygroup.atlassian.net/rest/api/2/issue/$jira_code"  --no-progress-meter | jq --raw-output .fields.issuetype.id
    )
    echo "IssueTypeId: $issue_type_id"

    issue_type='{"labels":["non-sprint"]}'
    if [[ $issue_type_id -eq 10010 ]];then
      issue_type='{"labels":["sprint"]}'
    fi

    echo "Body: $issue_type"

    pr_labels=$(
        curl -L \
            -X POST \
            -H "Accept: application/vnd.github+json" \
            -H "Authorization: Bearer $github_token" \
            -H "X-GitHub-Api-Version: 2022-11-28" \
            "https://api.github.com/repos/eskygroup/esky-content-providers/issues/$i/labels" \
            -d $issue_type \
            --no-progress-meter | jq 'map(.name)' -c
    )

    echo "PR labels: $pr_labels"
done